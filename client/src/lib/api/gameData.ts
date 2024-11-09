import { componentValueStore } from '$src/dojo/componentValueStore'
import type {
  SessionMeta,
  Global,
  Bullet,
  CharacterModel,
  CharacterPosition,
} from '$src/dojo/models.gen'
import { getDojo, accountStore, getDojoContext } from '$src/stores/dojoStore'
import {
  derived,
  readable,
  writable,
  type Readable,
  type Writable,
} from 'svelte/store'
import { account } from '$src/stores/account'
import { currentPlayer } from './player'
import { currentGlobal } from './global'
import { poseidonHash } from '@dojoengine/torii-wasm'
import { sessionMeta } from '$src/lib/api/sessionMeta'
import { get } from 'svelte/store'

export async function bullet(
  bullet_id: number
): Promise<Readable<Bullet | null>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(bullet_id)])

  return derived(
    [componentValueStore(clientComponents.Bullet, valueHash)],
    ([val], set) => {
      let result: Bullet = {
        ...val,
      }
      set(result)
    }
  )
}

export async function bullets(
  session_id: number
): Promise<Readable<Bullet[] | null>> {
  const SessionMeta = await sessionMeta(Number(session_id))

  return derived(SessionMeta, ($SessionMeta, set) => {
    if (!$SessionMeta?.bullets) {
      set(null)
      return
    }

    // Create an array of bullet stores
    const bulletStores = $SessionMeta.bullets.map(async (bulletId) => {
      return await bullet(Number(bulletId))
    })

    // Combine all bullet stores into a single array
    Promise.all(bulletStores).then((stores) => {
      const combinedStore = derived(stores, (bulletValues) =>
        bulletValues.filter((bullet) => bullet !== null)
      )
      set(get(combinedStore))
    })
  })
}

export async function characterModel(
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

export async function characterPosition(
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
