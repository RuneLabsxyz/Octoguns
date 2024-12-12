import { componentValueStore } from '$src/dojo/componentValueStore'
import type { Global } from '$src/dojo/models.gen'
import get from './utils'
import { getDojo } from '$src/stores/dojoStore'
import { derived, type Readable } from 'svelte/store'
import { account } from '$src/stores/account'
async function GlobalValue() {
  const { torii, clientComponents } = await getDojo()
  const valueHash = torii.poseidonHash([BigInt(0).toString()]) // global uses 0 as id

  const valueStore = componentValueStore(clientComponents.Global, valueHash)
  console.log('GlobalValue:', valueStore)
  // Subscribe to the store to log its actual value
  valueStore.subscribe((value) => {
    console.log('GlobalValue:', value)
  })

  return valueStore
}

export const currentGlobal: Readable<Global | null> = derived(
  [account],
  ([account], set) => {
    if (account?.address == undefined) {
      return
    }

    get(GlobalValue()).subscribe(set)
  }
)
