<script>
  import { isEnded } from '$stores/gameStores'
  import { onDestroy } from 'svelte'
  let win = false

  const unsubscribe = isEnded.subscribe((value) => {
    win = value
  })

  onDestroy(() => {
    unsubscribe()
  })

  function handleNext() {}
</script>

{#if win}
  <div
    class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 backdrop-blur-sm z-50"
  >
    <div class="bg-white p-6 rounded-lg shadow-lg text-center max-w-sm w-full">
      <h2 class="text-2xl font-semibold mb-4">You Win</h2>
      <button
        class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
        on:click={handleNext}
      >
        Next
      </button>
    </div>
  </div>
{/if}
