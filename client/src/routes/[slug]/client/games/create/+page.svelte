<script lang="ts">
  import { selectedMap } from '$stores/clientStores'
  import { goto } from '$app/navigation'
  import MiniMap from '$lib/MiniMap.svelte'
  import Button from '$lib/ui/Button.svelte'
  import TxToast from '$lib/ui/TxToast.svelte'
  import { cn } from '$lib/css/cn'
  import { SESSION_PRIMITIVES } from '$lib/consts'
  import { account, username, clearAccountStorage } from '$stores/account'
  import { env } from '$stores/network'
  import { createGame as createGameCall } from '$src/lib/api/actions'
  import { maps as mapsValue } from '$src/lib/api/maps'
  import { yourUnstartedSessions } from '$src/lib/api/sessions'
  import type { Map } from '$src/dojo/models.gen'
  import { accountStore } from '$src/stores/dojoStore'
  import { onMount } from 'svelte'

  let loadingToGame = false
  let localSelectedMap: number | null = $state(null)

  let maps: Map[] | null = $state(null)

  mapsValue.subscribe((mapValues) => {
    maps = mapValues
  })

  yourUnstartedSessions.subscribe((sessions) => {
    if (loadingToGame) {
      let session = sessions[-1]
      startSession(Number(session.session_id))
    }
  })

  function startSession(lastPlayerGameValue: number) {
    if (loadingToGame) {
      goto(`/${$env}/game/${lastPlayerGameValue}`)
    }
  }

  function selectMap(map_id: number) {
    selectedMap.set(map_id)
    localSelectedMap = map_id
    console.log('selected map', map_id)
  }

  let toastMessage = $state('')
  let toastStatus = $state('loading')
  let showToast = $state(false)
  const currentAccount = $derived($account ?? $accountStore)

  onMount(() => {
    window.addEventListener('unhandledrejection', (promiseRejectionEvent) => {
      console.error('unhandled: ', Error())
    })
  })

  async function createGame() {
    if (currentAccount) {
      console.log('SESSION_PRIMITIVES', SESSION_PRIMITIVES)
      console.log('selectedMap', $selectedMap)
      showToast = true
      toastMessage = 'Creating game...'
      toastStatus = 'loading'
      try {
        createGameCall($selectedMap, SESSION_PRIMITIVES)
        toastMessage = 'Game created successfully!'
        toastStatus = 'success'
        loadingToGame = true
      } catch (error) {
        console.error('Error creating game:', error)
        toastMessage = 'Failed to create game.'
        toastStatus = 'error'
        loadingToGame = false
      }
    } else {
      console.error('No active account found')
      toastMessage = 'No active account found.'
      toastStatus = 'error'
      showToast = true
    }
  }
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Select a map</h1>
    <span class="flex-grow"></span>
    <Button on:click={createGame}>Create game</Button>
  </div>

  <div
    class="grid grid-fill justify-around auto-cols-min px-3 overflow-auto overflow-x-hidden"
  >
    {#if maps}
      {#each maps as map}
        {#if map}
          <Button
            className="w-fit h-fit"
            selected={localSelectedMap === map.map_id}
            on:click={() => selectMap(Number(map.map_id))}
          >
            <MiniMap {map} />
          </Button>
        {/if}
      {/each}
    {/if}
  </div>
</div>

{#if showToast}
  <TxToast message={toastMessage} status={toastStatus} />
{/if}

<style>
  .grid-fill {
    grid-template-columns: repeat(auto-fill, 330px);
  }

  .map-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 16px;
    padding: 16px;
  }

  .flex {
    display: flex;
  }

  .justify-between {
    justify-content: space-between;
  }

  .p-4 {
    padding: 1rem;
  }

  .fixed {
    position: fixed;
  }

  .bottom-0 {
    bottom: 0;
  }

  .left-0 {
    left: 0;
  }

  .right-0 {
    right: 0;
  }
</style>
