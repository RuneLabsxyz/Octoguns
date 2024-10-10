import { getDojoConfig } from '../dojoConfig';
import { setup } from '$dojo/setup';
import { writable } from 'svelte/store';

export const dojoStore = writable();
export const isSetup = writable(false);

let setupPromise: Promise<void> | undefined;

async function setupInternal() {
  try {
    console.log('Initializing store...');
    const { dojoConfig, WORLD_ADDRESS } = getDojoConfig();
    const result = await setup(WORLD_ADDRESS, dojoConfig);
    console.log('Setup complete');
    dojoStore.set(result);
    isSetup.set(true);
  } catch (error) {
    console.error('Failed to initialize store:', error);
    isSetup.set(false);
  }
}

export async function initializeStore(force = false) {
  if (!setupPromise || force) {
    setupPromise = setupInternal();
  }
  return setupPromise;
}

export function waitForInitialization(): Promise<void> {
  return new Promise((ok, _) => {
    isSetup.subscribe(val => {
      if (val) {
        ok()
      }
    })
  })
}