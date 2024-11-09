<script lang="ts">
  import { createEventDispatcher } from 'svelte'
  import type { Session, SessionMeta } from '$src/dojo/models.gen'

  let { availableSessions, availableSessionMetas } = $props<{
    availableSessions: Session[] | null
    availableSessionMetas: SessionMeta[] | null
  }>()

  const dispatch = createEventDispatcher()

  let pendingSessions: Session[] = $derived(availableSessions)

  let showAll = $state(false)

  function onClick(session: any) {
    dispatch('select', session)
  }

  function toggleShowAll() {
    showAll = !showAll
  }

  let displayedSessions = $derived(
    showAll
      ? pendingSessions.slice().reverse()
      : pendingSessions.slice(-9).reverse()
  )
</script>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 mx-5 gap-3">
  {#if pendingSessions}
    {#each displayedSessions as session}
      <div
        class="flex justify-between items-center border-4 rounded-lg border-black flex-col w-full card"
      >
        <button
          class="border-t-4 py-2 w-full border-black hover:bg-gray-300"
          onclick={() => onClick(session)}
        >
          Join
        </button>
      </div>
    {/each}
  {/if}
</div>

{#if pendingSessions && pendingSessions.length > 9}
  <div class="flex justify-center mt-4">
    <button
      class="border-4 rounded-lg border-black py-2 px-4 hover:bg-gray-300"
      onclick={toggleShowAll}
    >
      {showAll ? 'Show Less' : 'Show All Games'}
    </button>
  </div>
{/if}

<style>
  .card {
    transition: all 0.3s;
  }

  .card:hover {
    box-shadow: black 6px 3px;
  }
</style>
