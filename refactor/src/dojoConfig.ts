import manifest from '../../contracts/manifests/dev/deployment/manifest.json'

import { createDojoConfig } from '@dojoengine/core'

export const dojoConfig = createDojoConfig({
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-debug/katana',
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-debug/torii',
  masterAddress: '0x56ac7c0b9dcc486be4995c0290d9396a9de6c84552558127c9209f00744eacb',
  masterPrivateKey: '0x3c2dd9eaf886d752a68ab5186330773ed7b8e6e0690e738d33b712a6f0486c1',
  manifest,
})

export type Config = typeof dojoConfig
