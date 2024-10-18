<script lang="ts">
  import { initializeStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { env } from '$stores/network'
  import { goto } from '$app/navigation'
  import { account } from '$src/stores/account.js'

  let isStoreInitialized = false

  async function initStore() {
    try {
      await initializeStore(true)
      console.log('Store initialized')
      isStoreInitialized = true
    } catch (error) {
      console.error('Failed to initialize store:', error)
    }
  }

  export let data
  let network = data.network

  onMount(async () => {
    env.set(network as 'mainnet' | 'slot')
    await initStore()

    if (!$account) {
      console.warn('No account! Redirecting...')
      goto('/')
    }
  })
</script>

{#if isStoreInitialized}
  <slot />
{:else}
  <div>Loading...</div>
{/if}
