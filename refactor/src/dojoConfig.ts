import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';


export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-demo/torii',
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-demo/katana',
  manifest,
});

export type Config = typeof dojoConfig;
