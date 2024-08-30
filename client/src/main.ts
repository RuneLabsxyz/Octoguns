import App from './App.svelte';
import { dojoConfig } from "../dojoConfig.ts";
import { setup, SetupResult } from "./dojo/setup.ts";
import { setupStore } from './stores.ts';

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

	return app;
  }
  
  export default initApp();