import { get } from 'svelte/store';
import manifest from '$manifests/deployment/manifest.json';
import { createDojoConfig } from '@dojoengine/core';
import { CONFIG } from '$stores/network'; 

export function getDojoConfig() {
  const configValue = get(CONFIG);

  const dojoConfig = createDojoConfig({
    toriiUrl: configValue.PUBLIC_TORII_URL,
    rpcUrl: configValue.PUBLIC_RPC_URL,
    manifest,
  });

  const WORLD_ADDRESS = configValue.PUBLIC_WORLD_ADDRESS;

  return { dojoConfig, WORLD_ADDRESS };
}
