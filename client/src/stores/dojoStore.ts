import { dojoConfig } from '../dojoConfig'
import { setup } from '$dojo/setup'
import { get, writable } from 'svelte/store'
import { Account } from 'starknet'
import { Contract } from 'starknet'
import { connect } from '$lib/controller'
import { account as accountStore } from '$src/stores/account'

type SetupResult = Awaited<ReturnType<typeof setup>>

export const dojoStore = writable<SetupResult>()
export const isSetup = writable(false)
export const settingUp = writable(false)

export const planeteloStore = writable<Contract | null>()

export async function initializeStore() {
  if (get(settingUp)) {
    console.warn('Concurrent setting up!')
    return await getDojo()
  }
  settingUp.set(true)

  try {
    console.log('Initializing store...')
    const result = await setup(
      '0x633afc7ba46094bb158889ba55487886c5748439433a555ca3ac16f502d7dc',
      dojoConfig
    )
    console.log('dojo store', result)
    console.log('setup complete')
    dojoStore.set(result)

    let res = await connect('sepolia')
    console.log(res)

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
  return [get(accountStore as any)!, dojo]
}
