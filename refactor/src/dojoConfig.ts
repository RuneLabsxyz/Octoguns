import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';


export const dojoConfig = createDojoConfig({
  manifest,
  toriiUrl: 'http://127.0.0.1:8080',
  rpcUrl: 'http://127.0.0.1:5050',
});

export type Config = typeof dojoConfig;
