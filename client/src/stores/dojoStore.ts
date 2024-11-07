import { dojoConfig } from '../dojoConfig'
import { setup } from '$dojo/setup'
import { get, writable } from 'svelte/store'
import { Account } from 'starknet'

type SetupResult = Awaited<ReturnType<typeof setup>>

export const dojoStore = writable<SetupResult>()
export const accountStore = writable<Account | null>()
export const isSetup = writable(false)
export const settingUp = writable(false)

export async function initializeStore() {
  if (get(settingUp)) {
    console.warn('Concurrent setting up!')
    return await getDojo()
  }
  settingUp.set(true)

  try {
    console.log('Initializing store...')
    const result = await setup('world_adress', dojoConfig)
    console.log('setup complete')
    dojoStore.set(result)

    accountStore.set(result.burnerManager.getActiveAccount())
    console.log('set stores')
    isSetup.set(true)

    dojoStore.subscribe((value) => {
      console.log(value)
    })
  } catch (error) {
    console.log('Failed to initialize store:', error)
    isSetup.set(false)
  } finally {
    settingUp.set(false)
  }
}

export async function getDojo(): Promise<SetupResult> {
  return new Promise((ok, err) => {
    dojoStore.subscribe((val) => {
      if (val) {
        ok(val)
      }
    })
    isSetup.subscribe((val) => {
      err('Failed to initalize store.')
    })
  })
}
