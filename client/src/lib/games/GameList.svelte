<script lang="ts">
  import { createEventDispatcher, onMount } from 'svelte'
  import { controllerMainnet, controllerSlot } from '$lib/controller'

  export let availableSessions: any

  const dispatch = createEventDispatcher()

  let pendingSessions: any[] = []
  let showAll = false
  let enemyControllerList: Record<string, string> = {}

  async function fetchUsernames() {
    const enemyAddressList = [
      ...new Set(
        availableSessions.map((session: any) => session.enemy as string)
      ),
    ] as string[]

    enemyControllerList =
      await controllerMainnet.fetchControllers(enemyAddressList)

    pendingSessions = availableSessions.map((session: { enemy: string }) => {
      const correctedEnemyAddress = addLeadingZero(session.enemy)
      return {
        ...session,
        enemy: correctedEnemyAddress,
        username: enemyControllerList[correctedEnemyAddress] || undefined,
      }
    })
  }

  function getHexPart(address: string): string {
    if (address.startsWith('0x')) {
      // remove the 0x
      return address.slice(2)
    }
    return address
  }

  function addLeadingZero(address: string): string {
    const hexPart = getHexPart(address)

    return '0x' + hexPart.padStart(64, '0')
  }

  function compressAddress(address: string): string {
    if (!address) return 'Not available'
    return `${address.slice(0, 6)}...${address.slice(-4)}`
  }

  function onClick(session: any) {
    dispatch('select', session)
  }

  function toggleShowAll() {
    showAll = !showAll
  }

  $: {
    if (availableSessions) {
      fetchUsernames()
    }
  }

  $: displayedSessions = showAll
    ? pendingSessions.slice().reverse()
    : pendingSessions.slice(-9).reverse()
</script>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 mx-5 gap-3">
  {#if pendingSessions.length > 0}
    {#each displayedSessions as session}
      <div
        class="flex justify-between items-center border-4 rounded-lg border-black flex-col w-full card"
      >
        <p class="flex-grow text-left p-5">
          {session.value}
          {session.username || compressAddress(session.enemy)}
          {#if session.isStarted && session.isYourTurn}
            <span class="ml-2 text-green-600 font-bold">Your Turn</span>
          {/if}
        </p>
        <button
          class="border-t-4 py-2 w-full border-black hover:bg-gray-300"
          on:click={() => onClick(session)}
        >
          Join
        </button>
      </div>
    {/each}
  {/if}
</div>

{#if pendingSessions.length > 9}
  <div class="flex justify-center mt-4">
    <button
      class="border-4 rounded-lg border-black py-2 px-4 hover:bg-gray-300"
      on:click={toggleShowAll}
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
