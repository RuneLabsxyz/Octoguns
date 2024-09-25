import manifest from '../../contracts/manifests/dev/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';

import { PUBLIC_TORII_URL, PUBLIC_KATANA_URL } from '$env/static/public';

export const dojoConfig = createDojoConfig({
  toriiUrl: PUBLIC_TORII_URL,
  rpcUrl: PUBLIC_KATANA_URL,
  manifest,
});

export type Config = typeof dojoConfig;
