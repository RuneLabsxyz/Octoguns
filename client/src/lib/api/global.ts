import { componentValueStore } from '$src/dojo/componentValueStore'
import type { Global } from '$src/dojo/models.gen'
import get from './utils'
import { getDojo, accountStore, getDojoContext } from '$src/stores/dojoStore'
import {
  derived,
  readable,
  writable,
  type Readable,
  type Writable,
} from 'svelte/store'

async function GlobalValue() {
  const { torii, clientComponents } = await getDojo()
  const valueHash = torii.poseidonHash(['0']) // global uses 0 as id

  return componentValueStore(clientComponents.Global, valueHash)
}

export const currentGlobal: Readable<Global | null> = derived(
  [accountStore],
  ([account], set) => {
    if (account?.address == undefined) {
      return
    }

    get(GlobalValue()).subscribe(set)
  }
)
