import manifest from '../../contracts/manifests/dev/deployment/manifest.json'

import { createDojoConfig } from '@dojoengine/core'

export const dojoConfig = createDojoConfig({
  manifest,
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-alpha1/katana',
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-alpha1/torii',
})

export type Config = typeof dojoConfig
