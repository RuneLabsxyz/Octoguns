import type {
  CharacterModel,
  CharacterPosition,
  SessionMeta,
} from '$src/dojo/models.gen'
import { derived, type Readable } from 'svelte/store'
import get from '../utils'
import type { Position } from '../gameState'
import { getDojo } from '$src/stores/dojoStore'
import { componentValueStore } from '$src/dojo/componentValueStore'

export type Character = {
  id: number
  playerId: bigint
  stepsAmount: number
  coords: Position
  maxSteps: number
  currentStep: number
}

export async function CharacterModelStore(
  entity_id: number
): Promise<Readable<CharacterModel>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(entity_id)])

  return derived(
    [componentValueStore(clientComponents.CharacterModel, valueHash)],
    ([val], set) => {
      let result: CharacterModel = {
        ...val,
      }
      console.log('CharacterModelStore', result)

      set(result)
    }
  )
}

export async function CharacterPositionStore(
  entity_id: number
): Promise<Readable<CharacterPosition>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(entity_id)])

  return derived(
    [componentValueStore(clientComponents.CharacterPosition, valueHash)],
    ([val], set) => {
      let result: CharacterPosition = {
        ...val,
      }
      console.log('CharacterPositionStore', result)

      set(result)
    }
  )
}

export function CharacterStore(
  characterId: number
): Readable<Character | null> {
  const characterModelStore = get(CharacterModelStore(characterId))
  const characterPositionStore = get(CharacterPositionStore(characterId))

  return derived(
    [characterModelStore, characterPositionStore],
    ([model, position]) => {
      console.log('CharacterStore', model, position)

      if (model == null || position == null) {
        return null
      }

      return {
        id: characterId,
        playerId: model.player_id as bigint,
        stepsAmount: Number(model.steps_amount),
        coords: {
          x: Number(position.coords.x),
          y: Number(position.coords.y),
        },
        maxSteps: Number(position.max_steps),
        currentStep: Number(position.current_step),
      }
    }
  )
}

export function CharactersStore(
  sessionMetaStore: Readable<SessionMeta | null>
): Readable<Character[] | null> {
  return derived([sessionMetaStore], ([sessionMeta], set) => {
    if (sessionMeta == null) {
      set(null)
      return
    }
    //@ts-ignore
    let p1 = sessionMeta.p1_characters.map((character) => CharacterStore(character.value))
    //@ts-ignore
    let p2 = sessionMeta.p2_characters.map((character) => CharacterStore(character.value))
    
    return derived(
      [...p1, ...p2],
      (chars) => chars
    ).subscribe((val) => {
      if (val.length == 0) {
        console.log('No characters')
        set(null)
      } else {
        // For some reason, the derived above is removing the size information,
        // so "as" it is
        set(val as Character[])
      }
    })
  })
}
