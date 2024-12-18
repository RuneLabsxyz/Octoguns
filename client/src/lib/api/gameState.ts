/// Handles the current game data.

import {
  derived,
  readonly,
  writable,
  type Readable,
  type Writable,
  get as getValue,
  type Unsubscriber,
  toStore,
} from 'svelte/store'
import get from './utils'
import { FRAME_INTERVAL, SESSION_PRIMITIVES } from '$lib/consts'
import type {
  Session,
  SessionMeta,
  Bullet as BulletTy,
  Bullet,
  Player,
} from '$src/dojo/models.gen'
import { getBulletPosition } from '$lib/helper'
import { isOutsideMapBoundary } from '$lib/3d/utils/shootUtils'
import type { GameStore } from './game'
import { CharacterStore, type Character } from './data/characters'
import { getDojoContext } from '$src/stores/dojoStore'
import { ControlsStore } from './controls/controls'
import { MoveStore } from './data/move'
import { playSoundEffect } from '$lib/3d/utils/audioUtils'
import { currentPlayer } from './player'
import { account } from '$stores/account'
import type { Action } from '$lib/api/data/move'
function handleMove() {
  //console.log('calldata', calldata)
  //TEMPORARY
  //REMOVE
  //@ts-ignore
}

export type GameState = ReturnType<typeof GameState>
export type Position = { x: number; y: number }

export type Marked<T> = T & { __marked?: string }

export type BulletWithPosition = BulletTy & {
  shot_at: Position
  position: Position
}

function bulletAt(
  bullet: BulletTy,
  turn: number,
  frame: number
): BulletWithPosition | null {
  const movesPerTurn = Number(SESSION_PRIMITIVES.sub_moves_per_turn)
  const bulletSubSteps = Number(SESSION_PRIMITIVES.bullet_sub_steps)
  const shotStep = Number(bullet.shot_step)
  console.log(movesPerTurn)
  console.log(bullet.shot_step)
  console.log(movesPerTurn * turn)
  console.log(bullet.shot_by)

  const frameDiff = movesPerTurn * turn + (frame / FRAME_INTERVAL) - (shotStep / bulletSubSteps)
  console.log(frameDiff)
  const position = getBulletPosition(bullet, frameDiff)

  // TODO: Check the boundaries in world scale

  return {
    ...bullet,
    shot_at: {
      x: Number(bullet.shot_at.x),
      y: Number(bullet.shot_at.y),
    },
    position,
  }
}

export function GameState(game: GameStore) {
  const unsubscribes: Unsubscriber[] = []
  const frameCounter = writable(0)

  const additionalBullets: Writable<Bullet[]> = writable([])

  const combinedBullets: Readable<Bullet[]> = derived(
    [game.bullets, additionalBullets],
    ([chainBullets, additionalBullets]) => {
      return [...(chainBullets ?? []), ...additionalBullets]
    }
  )

  const bullets: Readable<BulletWithPosition[] | null> = derived(
    [combinedBullets, frameCounter, game.turnCount],
    ([bullets, frame, turn]) => {
      if (bullets == null || turn == null) {
        return null
      }

      // Compute the new position of the bullet from the start and the number of frames.
      return bullets
        .map((bullet) => bulletAt(bullet, turn, frame))
        .filter((bullet) => bullet != null)
    }
  )

  let characters: Writable<Marked<Character> | null>[] = []

  // We also have to offer a way to temporarily move the characters.
  getValue(game.sessionMeta)?.p1_characters.map((val) => 
    {
      let character: Character | null = null;
      //@ts-ignore
      character = getValue(CharacterStore(val.value));
      characters.push(writable(character))
    }) ?? []

  getValue(game.sessionMeta)?.p2_characters.map((val) => 
    {
      let character: Character | null = null;
      //@ts-ignore
      character = getValue(CharacterStore(val.value));
      characters.push(writable(character))
    }) ?? []

  
  
  unsubscribes.push(
    game.characters.subscribe((updatedCharacters) => {
      if (updatedCharacters == null) {
        return
      }

      updatedCharacters.forEach((newCharacter, idx) => {
        characters[idx].update((currentCharacter) => {
          if (currentCharacter?.__marked) {
            return currentCharacter
          }

          // Deep clone the character
          return window.structuredClone(newCharacter)
        })
      })
    })
  )
  const controlsStore = ControlsStore()

  const currentCharactersValue = derived(
    [account, ...characters],
    ([player, ...characters]) => {
      if (player == null) {
        return null
      }
      let res: Marked<Character>[] = []
      for (let i = 0; i < characters.length; i++) {
        if (characters[i]?.playerId! != BigInt(player.address) || !characters[i]) {
          continue
        }
        res.push(characters[i]!)
      }

      return res
    }
  )

  const initialCharactersStore = derived(
    [account, game.characters],
    ([playerId, characters]) => {
      if (playerId == null) {
        return null
      }
      let res: Marked<Character>[] = []
      for (let i = 0; i < characters!.length; i++) {
        if (BigInt(characters![i].playerId) != BigInt(playerId.address)) {
          console.log('Skipping Character', characters![i])
          continue
        }
        console.log('Adding Initial Character', characters![i])
        res.push(characters![i])
      }

      return res
    }
  )

  const currentCharactersStore: Writable<Marked<Character>[] | null> & {
    reset: () => void
  } =
  {
    ...currentCharactersValue,
    update(t: (value: Marked<Character>[] | null) => Marked<Character>[] | null) {
      let subscription = () => {}
      let updated = false
      subscription = currentCharactersStore.subscribe((val) => {
        if (!updated) {
          updated = true
          currentCharactersStore.set(t(val))
          subscription()
        }
      })
    },
    set(value: Marked<Character>[] | null) {
      const playerId = getValue(game.currentPlayerId)
      if (playerId == null) {
        return null
      }
      characters.forEach((character) => {
        let id = getValue(character)!.id;
        value?.forEach((new_character) => {
          if (Number(new_character?.id) != Number(id)) {
            return
          }
          character.set(new_character)
        })
      })
    },
    reset() {
      currentCharactersStore.set(
        window.structuredClone(getValue(initialCharactersStore))
      )
    },
  }

  const moveStore = MoveStore({
    controlsStore,
    currentCharactersStore: currentCharactersStore,
    sessionIdStore: game.sessionId,
    frameCounterStore: frameCounter,
    currentPlayerIdStore: game.currentPlayerId,
    incrementFrame() {
      frameCounter.update((frame) => frame + 1)
    },
    resetFrameCounter() {
      frameCounter.set(0)
    },
    addAdditionalBullet(bullet) {
      additionalBullets.update((u) => {
        u.push(bullet)
        return u
      })

      // Add the sound
      playSoundEffect('/audio/sfx/shot.wav')
    },
    currentTurnStore: game.turnCount,
    resetAdditionalBullets() {
      additionalBullets.set([])
    },
  })


  return {
    ...game,
    // The readonly are only present to force usage of the provided functions
    frameCounter: readonly(frameCounter),
    bullets,
    characters,
    controls: controlsStore,
    move: moveStore,
    currentCharacters: currentCharactersStore,

    spawn: async () => {
      const [account, { client }] = await getDojoContext()
      console.log('Spawning!')
      await client.spawn.spawn({
        account: account,
        session_id: getValue(game.sessionId),
      })
    },
    /// destroy() MUST be called when the subscription is ending, it cleans up gracefully all subscriptions to the various stores
    /// required for this class to work.
    destroy: () => {
      unsubscribes.forEach((e) => e())
    },
  }
}
