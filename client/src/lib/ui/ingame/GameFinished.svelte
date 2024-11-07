<script lang="ts">
  import { run } from 'svelte/legacy';

  import {
    characterIds,
    currentPlayerId,
    isEnded,
  } from '$src/stores/gameStores'
  import Button from '$lib/ui/Button.svelte'
  import Banner from './Banner.svelte'

  let isWinner: boolean | null = $state(null)
  run(() => {
    if ($currentPlayerId != null) {
      // As defined in the contract, the winner is the player whose character id is not 0
      // id 0 means character is dead
      isWinner = !($characterIds[$currentPlayerId] === 0)
    }
  });
</script>

<Banner color={isWinner ? '#facc15' : '#2563eb'}>
  <div class="flex flex-col items-center gap-3">
    {#if isWinner}
      <h1 class="text-5xl font-bold text-white text-center">You win!</h1>
    {:else}
      <h1 class="text-5xl font-bold text-white">You lose!</h1>
    {/if}
    <p class="text-white text-center mt-2">
      {#if isWinner}
        Congratulations! You have won the game.
      {:else}
        Better luck next time!
      {/if}
    </p>

    <Button
      href="/client/games"
      class="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
      >Back to menu</Button
    >
  </div>
</Banner>
