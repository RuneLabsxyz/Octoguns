import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';

import {PUBLIC_TORII_URL, PUBLIC_RPC_URL, PUBLIC_BURNER_ADDRESS, PUBLIC_BURNER_KEY, PUBLIC_WORLD_ADDRESS} from '$env/static/public';

export const WORLD_ADDRESS = PUBLIC_WORLD_ADDRESS;

export const dojoConfig = createDojoConfig({
  toriiUrl: PUBLIC_TORII_URL,
  rpcUrl: PUBLIC_RPC_URL,
  manifest,
  masterAddress: PUBLIC_BURNER_ADDRESS,
  masterPrivateKey: PUBLIC_BURNER_KEY
});

export type Config = typeof dojoConfig;
