<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import Button from '$lib/ui/Button.svelte'
  import Banner from './Banner.svelte'

  const { sessionMeta, currentPlayerId } = getGame()

  let isWinner: boolean | null = $derived.by(() => {
    if ($currentPlayerId == null) {
      return null
    }

    return (
      ($sessionMeta?.p1_characters.length === 0 && $currentPlayerId == 2) ||
      ($sessionMeta?.p2_characters.length === 0 && $currentPlayerId == 1)
    )
  })
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
      className="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
      >Back to menu</Button
    >
  </div>
</Banner>
