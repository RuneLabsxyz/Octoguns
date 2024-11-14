<script lang="ts">
  import { initializeStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { env } from '$stores/network'

  let isStoreInitialized = false;

  async function initStore() {
    try {
      await initializeStore(true);
      console.log('Store initialized');
      isStoreInitialized = true; 
    } catch (error) {
      console.error('Failed to initialize store:', error);
    }
  }

  export let data
  let network = data.network

  onMount(async () => {
    env.set(network as "mainnet" | "slot" | "sepolia");
    await initStore();
  });
</script>

{#if isStoreInitialized}
  <slot />
{:else}
  <div>Loading...</div>
{/if}


