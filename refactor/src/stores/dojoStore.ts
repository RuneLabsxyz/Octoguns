import { dojoConfig } from "../dojoConfig";
import { setup } from "../dojo/setup";
import { writable } from 'svelte/store';

type SetupResult = ReturnType<typeof setup> extends Promise<infer R> ? R : never;

export const setupStore = writable<SetupResult | null>(null);
export const isSetup = writable(false);

export async function initializeStore() {
  try {
    console.log('Initializing store...');
    const result = await setup(dojoConfig);
    setupStore.set(result);
    isSetup.set(true);

    setupStore.subscribe((value) => {
      console.log(value);
    });
  } catch (error) {
    console.error('Failed to initialize store:', error);
    setupStore.set(null);
    isSetup.set(false);
  }
}
