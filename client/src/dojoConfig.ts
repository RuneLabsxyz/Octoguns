import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';


export const dojoConfig = createDojoConfig({
  manifest,
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-mn-alpha-1/torii',
  rpcUrl: 'https://api.cartridge.gg/x/starknet/mainnet',
});

export type Config = typeof dojoConfig;
