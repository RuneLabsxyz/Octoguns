import { dojoConfig } from '../dojoConfig'
import { setup } from '$dojo/setup'
import { get, writable } from 'svelte/store'
import { Account } from 'starknet'
import manifest from '../dojo/planetelo_sepolia_manifeset.json'
import { Contract } from 'starknet'
import { connect } from '$lib/controller'
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
      '0x05a968e49c6395f4d1137d579b2e02c342484cbaf33a535a2a6ba1c33a6c705a',
      dojoConfig
    )
    console.log('setup complete')
    dojoStore.set(result)

    await connect('sepolia');

    console.log('set stores')
    isSetup.set(true)

    dojoStore.subscribe((value) => {
      console.log(value)
    })

    let contracts = JSON.parse(JSON.stringify(manifest.contracts));
    const PlaneteloContract = new Contract(contracts[0].abi, contracts[0].address, result.dojoProvider.provider).typedv2(contracts[0].abi);
    console.log(PlaneteloContract);
    planeteloStore.set(PlaneteloContract);

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
