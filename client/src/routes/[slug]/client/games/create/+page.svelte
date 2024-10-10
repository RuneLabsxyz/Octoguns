<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import { selectedMap } from '$stores/clientStores'
  import { goto } from '$app/navigation'
  import { type Entity, getComponentValue } from '@dojoengine/recs'
  import MiniMap from '$lib/MiniMap.svelte'
  import Button from '$lib/ui/Button.svelte'
  import TxToast from '$lib/ui/TxToast.svelte'
  import { cn } from '$lib/css/cn'
  import { SESSION_PRIMITIVES } from '$lib/consts'
  import { account, username, clearAccountStorage } from '$stores/account'
  import { env } from '$stores/network';

  let loadingToGame = false
  let playerEntity: Entity
  let localSelectedMap: number | null = null
  let mapCount: number = 0

  $: ({ clientComponents, torii, client } = $dojoStore as any)

  $: globalentity = torii.poseidonHash([BigInt(0).toString()])

  $: if ($account) playerEntity = torii.poseidonHash([$account?.address])

  $: player = componentValueStore(clientComponents.Player, playerEntity)
  $: global = componentValueStore(clientComponents.Global, globalentity)
  let maps: any[] = []

  $: if ($global) {
    mapCount = $global.map_count
    maps = []
    for (let i = 0; i < mapCount; i++) {
      const map = getComponentValue(
        clientComponents.Map,
        torii.poseidonHash([BigInt(i).toString()])
      )
      maps.push(map)
    }
  }

  $: console.log('maps', maps)
  $: {
    localSelectedMap = $selectedMap
  }

  $: if ($player) {
    let lastPlayerGameValue =
      $player.games.length > 0
        ? $player.games[$player.games.length - 1].value
        : null
    startSession(lastPlayerGameValue)
  }

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

  let toastMessage = '';
  let toastStatus = 'loading';
  let showToast = false;

  async function createGame() {
    if ($account) {
      console.log('SESSION_PRIMITIVES', SESSION_PRIMITIVES)
      console.log('selectedMap', $selectedMap)
      showToast = true;
      toastMessage = 'Creating game...';
      toastStatus = 'loading';
      try {
        await client.start.create({
          account: $account,
          map_id: $selectedMap,
          session_primitives: SESSION_PRIMITIVES,
        })
        toastMessage = 'Game created successfully!';
        toastStatus = 'success';
        loadingToGame = true;
      } catch (error) {
        console.error('Error creating game:', error);
        toastMessage = 'Failed to create game.';
        toastStatus = 'error';
        loadingToGame = false;
      }
    } else {
      console.error('No active account found')
      toastMessage = 'No active account found.';
      toastStatus = 'error';
      showToast = true;
    }
  }

  function goBack() {
    goto('/client/games')
  }

  function disconnect() {
    clearAccountStorage();
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
    {#each maps as map}
      {#if map}
        <Button
          className="w-fit h-fit"
          selected={localSelectedMap === map.map_id}
          on:click={() => selectMap(map.map_id)}
        >
          <MiniMap {map} />
        </Button>
      {/if}
    {/each}
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
