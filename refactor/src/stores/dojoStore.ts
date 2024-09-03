import { dojoConfig } from "../dojoConfig";
import { setup } from "../dojo/setup";
import { writable } from 'svelte/store';

type SetupResult = Awaited<ReturnType<typeof setup>>;

export const dojoStore = writable<SetupResult>();
export const isSetup = writable(false);

export async function initializeStore() {
  try {
    console.log('Initializing store...');
    const result = await setup(dojoConfig);
    dojoStore.set(result);
    isSetup.set(true);

    dojoStore.subscribe((value) => {
      console.log(value);
    });
  } catch (error) {
    console.error('Failed to initialize store:', error);
    isSetup.set(false);
  }
}
