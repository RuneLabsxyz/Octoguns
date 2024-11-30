import { dojoConfig } from '../dojoConfig'
import { setup } from '$dojo/setup'
import { get, writable } from 'svelte/store'
import { Account, Contract } from 'starknet'

type SetupResult = Awaited<ReturnType<typeof setup>>

export const dojoStore = writable<SetupResult>()
export const accountStore = writable<Account | null>()
export const isSetup = writable(false)
export const settingUp = writable(false)
export const planeteloStore = writable<Contract>()

export async function initializeStore() {
  if (get(settingUp)) {
    console.warn('Concurrent setting up!')
    return await getDojo()
  }
  settingUp.set(true)

  try {
    console.log('Initializing store...')
    const result = await setup(
      '0x05fc7c43609c968a82ad003e33cbdc2171649cea8dd2a3944dd0525d68bbee3a',
      dojoConfig
    )
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

export async function getDojoContext(): Promise<[Account, SetupResult]> {
  const dojo = await getDojo()
  return [dojo.burnerManager.getActiveAccount()!, dojo]
}