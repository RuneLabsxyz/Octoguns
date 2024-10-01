import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';


export const dojoConfig = createDojoConfig({
  manifest,
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-public-alpha1/torii',
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-public-alpha1/katana',
});

export type Config = typeof dojoConfig;
