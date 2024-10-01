<script lang="ts">
  import '../app.css'
  import { onMount } from 'svelte'
  import { initializeStore, waitForInitialization } from '$stores/dojoStore'
  import { writable } from 'svelte/store'
  import { page } from '$app/stores'

  let storePromise: Promise<[void, void]> = Promise.all([
    initStore(),
    waitForInitialization(),
  ])

  async function initStore() {
    try {
      await initializeStore()
      console.log('store initialized')
    } catch (error) {
      console.error('Failed to initialize store:', error)
    }
  }
</script>

{#await storePromise}
  <p>Loading...</p>
{:then _}
  <slot />
{/await}
