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
export type SetupResult = Awaited<ReturnType<typeof setup>>

export async function setup({ ...config }: DojoConfig) {
  // torii client
  const toriiClient = await torii.createClient({
    rpcUrl: config.rpcUrl,
    toriiUrl: config.toriiUrl,
    relayUrl: '',
    worldAddress:
      '0x7447477a7c852c946f0b8d13ebdfe0db9e78f3de60ab799320691502b4d32a3' || '',
  })

  // create contract components
  const contractComponents = defineContractComponents(world)

  // create client components
  const clientComponents = createClientComponents({ contractComponents })

  // create dojo provider
  const dojoProvider = new DojoProvider(config.manifest, config.rpcUrl)

  const sync = await getSyncEntities(toriiClient, contractComponents as any, [])

  // setup world
  const client = await setupWorld(dojoProvider)

  // create burner manager
  const burnerManager = new BurnerManager({
    masterAccount: new Account(
      {
        nodeUrl: config.rpcUrl,
      },
      '0x9b4fea3bb27903a996426a7bd4cd33a23e1187942cf19c6f7611b4db333bee',
      '0x2a79be0d524b62728aa13f63e180a18224cb6205d78473559ccb94957a23814'
    ),
    accountClassHash: config.accountClassHash,
    rpcProvider: dojoProvider.provider,
    feeTokenAddress: '0x0',
  })

  try {
    await burnerManager.init()
    if (burnerManager.list().length === 0) {
      await burnerManager.create()
    }
  } catch (e) {
    console.error(e)
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
