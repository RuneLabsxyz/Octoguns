import { componentValueStore } from '$src/dojo/componentValueStore'
import type { Player } from '$src/dojo/models.gen'
import { getDojo, getDojoContext, accountStore } from '$src/stores/dojoStore'
import {
  derived,
  readable,
  writable,
  type Readable,
  type Writable,
} from 'svelte/store'
import get from './utils'

async function Player(address: string) {
  // We consider they are unchangeable
  const { torii, clientComponents } = await getDojo()
  const valueHash = torii.poseidonHash([address])

  // return a component value store of the object:
  return componentValueStore(clientComponents.Player, valueHash)
}

export const currentPlayer: Readable<Player | null> = derived(
  [accountStore],
  ([account], set) => {
    if (account?.address == undefined) {
      return
    }

    get(Player(account?.address)).subscribe(set)
  }
)
