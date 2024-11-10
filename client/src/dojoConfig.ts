import { get } from 'svelte/store';
import manifest from '../../contracts/octoguns/manifest_dev.json';
import { createDojoConfig } from '@dojoengine/core';
import { CONFIG } from '$stores/network'; 

export function getDojoConfig() {
  const configValue = get(CONFIG);
  console.log(configValue);

  
  const dojoConfig = createDojoConfig({
    rpcUrl: 'https://api.cartridge.gg/x/starknet/sepolia',
    toriiUrl: 'https://api.cartridge.gg/x/planetelo/torii',
    manifest,
  });

  return { dojoConfig };
}
