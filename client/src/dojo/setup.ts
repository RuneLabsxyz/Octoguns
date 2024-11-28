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
import { env } from '$src/stores/network'
import { get } from 'svelte/store'
import { planeteloStore } from '$src/stores/dojoStore'
import manifest from './planetelo_sepolia_manifeset.json'
import { Contract } from 'starknet'

export type SetupResult = Awaited<ReturnType<typeof setup>>

export async function setup(
  worldAddress: string | undefined,
  { ...config }: DojoConfig
) {
  // torii client
  const toriiClient = await torii.createClient({
    rpcUrl: config.rpcUrl,
    toriiUrl: config.toriiUrl,
    relayUrl: '',
    worldAddress: '0x06040f9fc60298b4f01526ea9ee4bdbfcbd1e3842ddafcb223e684cc8f3e6efd',
  })

  // create contract components
  const contractComponents = defineContractComponents(world)

  // create client components
  const clientComponents = createClientComponents({ contractComponents })

  // create dojo provider
  const dojoProvider = new DojoProvider(config.manifest, config.rpcUrl)

  const sync = await getSyncEntities(
    toriiClient,
    contractComponents as any,
    undefined,
    []
  )

  let contracts = JSON.parse(JSON.stringify(manifest.contracts));
  console.log(contracts[0]);

  const myTestContract = new Contract(contracts[0].abi, contracts[0].address, dojoProvider.provider).typedv2(contracts[0].abi);
  console.log(myTestContract);
  planeteloStore.set(myTestContract);

  // setup world
  const client = await setupWorld(dojoProvider)
  console.log('client', client)

  const burnerManager = new BurnerManager({
    masterAccount: new Account(
      {
        nodeUrl: config.rpcUrl,
      },
      config.masterAddress,
      config.masterPrivateKey
    ),
    accountClassHash: config.accountClassHash,
    rpcProvider: dojoProvider.provider,
    feeTokenAddress: config.feeTokenAddress,
  })

  return {
    client,
    clientComponents,
    contractComponents,
    publish: (typedData: string, signature: ArraySignatureType) => {
      toriiClient.publishMessage(typedData, signature)
    },
    config,
    dojoProvider,
    burnerManager,
    toriiClient,
    torii,
    sync,
  }
}
