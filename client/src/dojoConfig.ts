import { get } from 'svelte/store'
//import manifest from '$manifests/manifest_slot.json'
import { createDojoConfig } from '@dojoengine/core'
import { CONFIG } from '$stores/network'
import manifest from '../../contracts/octoguns/manifest_sepolia.json'

/*
export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-alpha2/torii',
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-alpha2/katana',
  manifest,
})
  */
 export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-sepolia/torii',
  rpcUrl: 'https://api.cartridge.gg/x/starknet/sepolia',
  manifest,
})

export type Config = typeof dojoConfig
