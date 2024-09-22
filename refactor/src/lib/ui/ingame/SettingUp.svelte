<script lang="ts">
  import { currentPlayerId } from '$src/stores/gameStores'
  import Background from '../Background.svelte'
  import Overlay from './Overlay.svelte'
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
