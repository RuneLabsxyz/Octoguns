<script lang="ts">
  import '../app.css'
  import { onMount } from 'svelte'
  import { initializeStore } from '$stores/dojoStore'
  import { writable } from 'svelte/store'
  import { page } from '$app/stores'

  const isStoreInitialized = writable(false)

  async function initStore() {
    try {
      await initializeStore()
      isStoreInitialized.set(true)
      console.log('store initialized')
    } catch (error) {
      console.error('Failed to initialize store:', error)
      isStoreInitialized.set(false)
    }
  }

  onMount(() => {
    initStore()
  })

  $: {
    $page.url
    initStore()
  }
</script>

{#if $isStoreInitialized}
  <slot />
{:else}
  <p>Loading...</p>
{/if}
