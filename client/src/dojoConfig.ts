import { get } from 'svelte/store'
import manifest from '$manifests/manifest_dev.json'
import { createDojoConfig } from '@dojoengine/core'
import { CONFIG } from '$stores/network'

export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-alpha2/torii',
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-alpha2/katana',
  manifest,
})

export type Config = typeof dojoConfig
