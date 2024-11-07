<script lang="ts">
  import { initializeStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { env } from '$stores/network'

  let isStoreInitialized = $state(false);

  async function initStore() {
    try {
      await initializeStore(true);
      console.log('Store initialized');
      isStoreInitialized = true; 
    } catch (error) {
      console.error('Failed to initialize store:', error);
    }
  }

  let { data, children } = $props();
  let network = data.network

  onMount(async () => {
    env.set(network as "mainnet" | "slot");
    await initStore();
  });
</script>

{#if isStoreInitialized}
  {@render children?.()}
{:else}
  <div>Loading...</div>
{/if}


