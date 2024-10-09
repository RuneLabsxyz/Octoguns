import manifest from '$manifests/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';

import {PUBLIC_TORII_URL, PUBLIC_RPC_URL, PUBLIC_WORLD_ADDRESS} from '$env/static/public';

export const WORLD_ADDRESS = PUBLIC_WORLD_ADDRESS;

export const dojoConfig = createDojoConfig({
  toriiUrl: PUBLIC_TORII_URL,
  rpcUrl: PUBLIC_RPC_URL,
  manifest,
});

export type Config = typeof dojoConfig;
