//TODO(Red): Upgrade this to a proper store with funciton calls.

import { writable } from 'svelte/store'
import type { AccountInterface } from 'starknet'
import { controllerMainnet, controllerSlot } from '$lib/controller' // Add this import

function createPersistentStore<T>(key: string, initialValue: T) {
  const storedValue = localStorage.getItem(key)
  let initial = initialValue
  if (storedValue !== null && storedValue !== 'undefined') {
    try {
      initial = JSON.parse(storedValue)
    } catch (e) {
      console.error(`Error parsing stored value for ${key}:`, e)
    }
  }
  const store = writable<T>(initial)

  store.subscribe((value) => {
    if (value === undefined) {
      localStorage.removeItem(key)
    } else {
      localStorage.setItem(key, JSON.stringify(value))
    }
  })

  return store
}

export const account = createPersistentStore<AccountInterface | undefined>(
  'octoguns_account',
  undefined
)
export const username = createPersistentStore<string | undefined>(
  'octoguns_username',
  undefined
)

export async function clearAccountStorage() {
  localStorage.removeItem('octoguns_account')
  localStorage.removeItem('octoguns_username')
  account.set(undefined)
  username.set(undefined)
  await controllerMainnet.disconnect()
  await controllerSlot.disconnect()
}
