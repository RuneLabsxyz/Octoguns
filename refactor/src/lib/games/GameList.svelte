<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore)

  export let availableSessions

  $: pendingSessions = availableSessions

  $: account = burnerManager.getActiveAccount()

  async function joinSession(session: any) {
    if (account) {
      console.log('Joining session', session.value)
      await client.start.join({ account: account, session_id: session.value })
      window.location.href = `/game/${session.value}`
    } else {
      console.error('No active account found')
    }
  }
</script>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 mx-5 gap-3">
  {#if pendingSessions}
    {#each availableSessions.slice().reverse() as session}
      <div
        class="flex justify-between items-center border-4 rounded-lg border-black flex-col w-full card"
      >
        <p class="flex-grow text-left p-5">{session.value}</p>
        <button
          class="border-t-4 py-2 w-full border-black hover:bg-gray-300"
          on:click={() => joinSession(session)}
        >
          Join
        </button>
      </div>
    {/each}
  {/if}
</div>

<style>
  .card {
    transition: all 0.3s;
  }

  .card:hover {
    box-shadow: black 6px 3px;
  }
</style>
