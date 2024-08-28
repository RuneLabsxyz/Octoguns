import App from './App.svelte';
import { dojoConfig } from "../dojoConfig.ts";
import { setup, SetupResult } from "./dojo/setup.ts";
import { writable } from 'svelte/store';

export const setupStore = writable<SetupResult>();

async function initApp() {
	// Update the store with the setup result
	setupStore.set(await setup(dojoConfig));
  
	setupStore.subscribe((value) => {
	  console.log(value);
	});
  
	console.log("App initialized");
  
	const app = new App({
	  target: document.body,
	});

	console.log(setupStore);
	return app;
  }
  
  export default initApp();