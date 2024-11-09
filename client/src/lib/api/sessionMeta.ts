import { componentValueStore } from '$src/dojo/componentValueStore'
import type { SessionMeta, Global } from '$src/dojo/models.gen'
import get from './utils'
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

export async function sessionMeta(
  session_id: number
): Promise<Readable<SessionMeta | null>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(session_id)])

  return derived(
    [componentValueStore(clientComponents.SessionMeta, valueHash)],
    ([val], set) => {
      let result: SessionMeta = {
        ...val,
      }
      set(result)
    }
  )
}
