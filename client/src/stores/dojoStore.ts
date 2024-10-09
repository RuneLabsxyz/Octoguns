import { dojoConfig, WORLD_ADDRESS } from '../dojoConfig'
import { setup } from '$dojo/setup'
import { writable } from 'svelte/store'
import { Account } from 'starknet'

type SetupResult = Awaited<ReturnType<typeof setup>>

export const dojoStore = writable<SetupResult>()
export const isSetup = writable(false)

let setupPromise: Promise<void> | undefined;

async function setupInternal() {
  try {
    console.log('Initializing store...')
    const result = await setup(WORLD_ADDRESS, dojoConfig)
    console.log('setup complete')
    dojoStore.set(result)
    console.log('set stores')
    isSetup.set(true)

    dojoStore.subscribe((value) => {
      console.log(value)
    })
  } catch (error) {
    console.error('Failed to initialize store:', error)
    isSetup.set(false)
  }
}

export async function initializeStore() {
  if (setupPromise == undefined) {
    setupPromise = setupInternal();
  } else {
    return setupPromise;
  }
}
export function waitForInitialization(): Promise<void> {
  return new Promise((ok, _) => {
    isSetup.subscribe(val => {
      if (val) {
        ok()
      }
    })
  })
}