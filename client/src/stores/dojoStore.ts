import { getDojoConfig } from '../dojoConfig';
import { setup, type SetupResult } from '$dojo/setup';
import { get, writable } from 'svelte/store';

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

export async function getDojo(): Promise<SetupResult> {
  if (get(isSetup)) {
    return get(dojoStore) as SetupResult;
  } else {
    await waitForInitialization();
    return get(dojoStore) as SetupResult;
  }
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