import type { DojoConfig } from '@dojoengine/core'
import { DojoProvider } from '@dojoengine/core'
import * as torii from '@dojoengine/torii-client'
import { createClientComponents } from './createClientComponents'
import { defineContractComponents } from './models.gen'
import { world } from './world'
import { setupWorld } from './contracts.gen'
import { Account } from 'starknet'
import type { ArraySignatureType } from 'starknet'
import { BurnerManager } from '@dojoengine/create-burner'
import { getSyncEntities, getSyncEvents } from '@dojoengine/state'
import { account } from '$src/stores/account'
import manifest from './manifest_sepolia.json'
import { Contract } from 'starknet'
import { planeteloStore } from '$src/stores/dojoStore'
export type SetupResult = Awaited<ReturnType<typeof setup>>

export async function setup(
  worldAddress: string | undefined,
  { ...config }: DojoConfig
) {
  // torii client
  const toriiClient = await torii.createClient({
    rpcUrl: 'https://api.cartridge.gg/x/starknet/sepolia',
    toriiUrl: 'https://api.cartridge.gg/x/planetelo/torii',
    relayUrl: '',
    worldAddress:
      '0x633afc7ba46094bb158889ba55487886c5748439433a555ca3ac16f502d7dc',
  })

  // create contract components
  const contractComponents = defineContractComponents(world)

  // create client components
  const clientComponents = createClientComponents({ contractComponents })

  // create dojo provider
  const dojoProvider = new DojoProvider(
    config.manifest,
    'https://api.cartridge.gg/x/starknet/sepolia'
  )
  console.log(dojoProvider)

  const sync = await getSyncEntities(
    toriiClient,
    contractComponents as any,
    undefined,
    []
  )

  let contracts = JSON.parse(JSON.stringify(manifest.contracts))
  console.log(contracts[0])

  const myTestContract = new Contract(
    contracts[0].abi,
    contracts[0].address,
    dojoProvider.provider
  ).typedv2(contracts[0].abi)
  planeteloStore.set(myTestContract)
  // setup world
  // setup world
  const client = await setupWorld(dojoProvider)
  // create burner manager
  // const burnerManager = new BurnerManager({
  //   masterAccount: new Account(
  //     {
  //       nodeUrl: config.rpcUrl,
  //     },
  //     config.masterAddress,
  //     config.masterPrivateKey
  //   ),
  //   accountClassHash: config.accountClassHash,
  //   rpcProvider: dojoProvider.provider,
  //   feeTokenAddress: config.feeTokenAddress,
  // })

  // try {
  //   console.log('Starting burner!')
  //   await burnerManager.init()
  //   if (burnerManager.list().length === 0) {
  //     await burnerManager.create()
  //   }
  // } catch (e) {
  //   console.error('An error occurred while creating burner:', e)
  // }

  return {
    client,
    clientComponents,
    contractComponents,
    publish: (typedData: string, signature: ArraySignatureType) => {
      toriiClient.publishMessage(typedData, signature)
    },
    config,
    dojoProvider,
    // burnerManager,
    toriiClient,

    torii,
    sync,
  }
}
