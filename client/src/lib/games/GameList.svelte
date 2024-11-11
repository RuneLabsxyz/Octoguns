<script lang="ts">
  import type { Session, SessionMeta } from '$src/dojo/models.gen'
  import { joinGame } from '$lib/api/actions'
  import { yourActiveSessions } from '$lib/api/sessions'
  import { onMount } from 'svelte'

  let { availableSessions, availableSessionMetas, contractCall } = $props<{
    availableSessions: Session[] | null
    availableSessionMetas: SessionMeta[] | null
    contractCall: boolean
  }>()

  let isLoadingJoin = $state(false)
  let activeSessions = $derived(yourActiveSessions)

  $effect(() => {
    if (activeSessions && isLoadingJoin) {
      window.location.href = `/slot/client/games/session/${$activeSessions[$activeSessions.length - 1].session_id}`
    }
  })

  $effect(() => {
    if (activeSessions && isLoadingJoin) {
    }
  })

  let pendingSessions: Session[] = $derived(availableSessions)

  let showAll = $state(false)

  function toggleShowAll() {
    showAll = !showAll
  }

  let displayedSessions = $derived(
    showAll
      ? pendingSessions.slice().reverse()
      : pendingSessions.slice(-9).reverse()
  )

  function joiningGame(sessionId: number) {
    if (!contractCall) {
      window.location.href = `/slot/game/${sessionId}`
    } else {
      //TODO handle call to contract + listner
    }
    // isLoadingJoin = true
  }
</script>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 mx-5 gap-3">
  {#if pendingSessions}
    {#each displayedSessions as session}
      <div
        class="flex justify-between items-center border-4 rounded-lg border-black flex-col w-full card"
      >
        <button
          class="border-t-4 py-2 w-full border-black hover:bg-gray-300"
          onclick={() => joiningGame(Number(session.session_id))}
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
