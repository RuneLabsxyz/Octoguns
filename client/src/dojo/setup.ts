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
    worldAddress: '0x05a968e49c6395f4d1137d579b2e02c342484cbaf33a535a2a6ba1c33a6c705a',
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

  // setup world
  const client = await setupWorld(dojoProvider)
  console.log('client', client)


  return {
    client,
    clientComponents,
    contractComponents,
    publish: (typedData: string, signature: ArraySignatureType) => {
      toriiClient.publishMessage(typedData, signature)
    },
    config,
    dojoProvider,
    toriiClient,

    torii,
    sync,
  }
}
