<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import Background from '$lib/ui/Background.svelte'
  import { onMount } from 'svelte'
  import Overlay from './Overlay.svelte'
  import { account } from '$src/stores/account'
  const { currentPlayerId, session, spawn } = getGame()

  // Spawn if the setup is ready
  $effect(() => {
    if ($session?.state === 1 && $account && $currentPlayerId === 2) {
      console.log('Spawning characters!')
      spawn()
    }
  })
</script>

<Overlay>
  <Background />
  <div class="flex flex-col justify-center items-center h-screen">
    <div
      class="flex justify-center items-center flex-col bg-white p-10 rounded-lg border-black border-4"
    >
      {#if $currentPlayerId === 1}
        <h1 class="text-3xl font-bold">A player has joined !</h1>
      {:else if $currentPlayerId === 2}
        <h1 class="text-3xl font-bold">Joining...</h1>
      {/if}
      <p>Preparing the arena...</p>
    </div>
  </div>
</Overlay>
