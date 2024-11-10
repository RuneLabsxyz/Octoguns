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
} from '$src/dojo/models.gen'
import { getBulletPosition } from '$lib/helper'
import { isOutsideMapBoundary } from '$lib/3d/utils/shootUtils'
import type { GameStore } from './game'
import type { Character } from './data/characters'
import { getDojoContext } from '$src/stores/dojoStore'
import { ControlsStore } from './controls/controls'
import { MoveStore } from './data/move'

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
  const shotStep = Number(bullet.shot_step)

  const frameDiff = movesPerTurn * turn + frame / FRAME_INTERVAL - shotStep

  const position = getBulletPosition(bullet, frameDiff)

  // Ignore all bullets outside of the map boundaries.
  if (isOutsideMapBoundary(position.x, position.y)) {
    return null
  }

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

  const bullets: Readable<BulletWithPosition[] | null> = derived(
    [game.bullets, frameCounter, game.turnCount],
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

  // We also have to offer a way to temporarily move the characters.
  const characters: Writable<Marked<Character> | null>[] = [
    writable(),
    writable(),
  ]

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

          return newCharacter
        })
      })
    })
  )
  const controlsStore = ControlsStore()

  // Red: This may break badly :/
  const currentCharacterStore = toStore(
    () => {
      const playerId = getValue(game.currentPlayerId)
      if (playerId == null) {
        return null
      }
      return getValue(characters[playerId])
    },
    (newCharacter) => {
      const playerId = getValue(game.currentPlayerId)
      if (playerId == null) {
        return null
      }

      characters[playerId].set(newCharacter)
    }
  )

  const initialCharacterStore = derived(
    [game.currentPlayerId, game.characters],
    ([playerId, characters]) => {
      if (playerId == null) {
        return null
      }
      return (characters ?? [null, null])[playerId - 1]
    }
  )

  const moveStore = MoveStore({
    controlsStore,
    currentCharacterStore: currentCharacterStore,
    sessionIdStore: game.sessionId,
    initialCharacterStore: initialCharacterStore,
    frameCounterStore: frameCounter,
    incrementFrame() {
      frameCounter.update((frame) => frame + 1)
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
