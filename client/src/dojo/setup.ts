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
    worldAddress:
      '0x0254890d63e60b43d0c8cbc6e69044e094cb2abadd01f4ff03786a05a6814cad',
  })

  // create contract components
  const contractComponents = defineContractComponents(world)

  // create client components
  const clientComponents = createClientComponents({ contractComponents })

  // create dojo provider
  const dojoProvider = new DojoProvider(config.manifest, config.rpcUrl)

  console.log(dojoProvider)

  const sync = await getSyncEntities(
    toriiClient,
    contractComponents as any,
    undefined,
    []
  )

  // setup world
  const client = await setupWorld(dojoProvider)
  // create burner manager
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

  try {
    console.log('Starting burner!')
    await burnerManager.init()
    if (burnerManager.list().length === 0) {
      await burnerManager.create()
    }
  } catch (e) {
    console.error('An error occurred while creating burner:', e)
  }

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
