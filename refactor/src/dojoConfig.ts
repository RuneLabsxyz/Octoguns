import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';
import { PUBLIC_TORII_URL } from '$env/static/public';

export const dojoConfig = createDojoConfig({
  toriiUrl: 'https://api.cartridge.gg/x/octoguns-demo/torii',
  rpcUrl: 'https://api.cartridge.gg/x/octoguns-demo/katana',
  manifest,
  toriiUrl: PUBLIC_TORII_URL ,
});

export type Config = typeof dojoConfig;
