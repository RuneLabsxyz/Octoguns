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
): Readable<[Character, Character] | null> {
  return derived([sessionMetaStore], ([sessionMeta], set) => {
    if (sessionMeta == null) {
      set(null)
      return
    }

    return derived(
      [
        CharacterStore(Number(sessionMeta.p1_character)),
        CharacterStore(Number(sessionMeta.p2_character)),
      ],
      ([p1, p2]) => [p1, p2]
    ).subscribe((val) => {
      if (val[0] == null || val[1] == null) {
        set(null)
      } else {
        // For some reason, the derived above is removing the size information,
        // so "as" it is
        set(val as [Character, Character])
      }
    })
  })
}
