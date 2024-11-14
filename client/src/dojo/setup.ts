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
import { Contract } from 'starknet'
import { planeteloStore } from '$stores/dojoStore'
import manifest from '../../../contracts/planetelo/manifest_sepolia.json'

console.log(manifest.world.address)


export type SetupResult = Awaited<ReturnType<typeof setup>>

export async function setup({ ...config }: DojoConfig) {
  // torii client
  const toriiClient = await torii.createClient({
    rpcUrl: config.rpcUrl,
    toriiUrl: 'http://localhost:8080',
    relayUrl: '',
    worldAddress: '0x761d393cd0e7e91f008395bc1401928c145802b6a3b99bcfb712dc73bf0a1e6'
  })

  // create contract components
  const contractComponents = defineContractComponents(world)

  // create client components
  const clientComponents = createClientComponents({ contractComponents })

  // create dojo provider
  const dojoProvider = new DojoProvider(config.manifest, config.rpcUrl)
  
  console.log(JSON.parse(JSON.stringify(manifest)));

  const sync = await getSyncEntities(toriiClient, contractComponents as any, undefined, [])

  let contracts = JSON.parse(JSON.stringify(manifest.contracts));
  console.log(contracts[0]);

  const myTestContract = new Contract(contracts[0].abi, contracts[0].address, dojoProvider.provider).typedv2(contracts[0].abi);
  console.log(myTestContract);
  planeteloStore.set(myTestContract);
  // setup world
  const client = await setupWorld(dojoProvider)

  // create burner manager
  // const burnerManager = new BurnerManager({
  //   masterAccount: new Account(
  //     {
  //       nodeUrl: config.rpcUrl,
  //     },
  //     KATANA_PREFUNDED_ADDRESS,
  //     KATANA_PREFUNDED_PRIVATE_KEY
  //   ),
  //   accountClassHash: config.accountClassHash,
  //   rpcProvider: dojoProvider.provider,
  //   feeTokenAddress: config.feeTokenAddress,
  // })

  // try {
  //   await burnerManager.init()
  //   if (burnerManager.list().length === 0) {
  //     await burnerManager.create()
  //   }
  // } catch (e) {
  //   console.error(e)
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
