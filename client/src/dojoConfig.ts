import { get } from 'svelte/store'
import manifest from './dojo/manifest_octoguns_sepolia.json'
import { createDojoConfig } from '@dojoengine/core'
import { CONFIG } from '$stores/network'

export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/planetelo/torii',
  rpcUrl: 'https://api.cartridge.gg/x/starknet/sepolia',
  manifest,
})

export type Config = typeof dojoConfig
