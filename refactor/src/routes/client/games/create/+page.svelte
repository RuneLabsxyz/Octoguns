<script lang="ts">
  import { accountStore, dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import { selectedMap } from '$stores/clientStores'
  import { goto } from '$app/navigation'
  import { type Entity, getComponentValue } from '@dojoengine/recs'
  import MiniMap from '$lib/MiniMap.svelte'

  let loadingToGame = false
  let playerEntity: Entity
  let mapCount: number = 0

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any)

  $: account = $accountStore
  $: globalentity = torii.poseidonHash([BigInt(0).toString()])

  $: if ($accountStore) playerEntity = torii.poseidonHash([account?.address])

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

  $: if ($player) {
    let lastPlayerGameValue =
      $player.games.length > 0
        ? $player.games[$player.games.length - 1].value
        : null
    startSession(lastPlayerGameValue)
  }

  function startSession(lastPlayerGameValue: number) {
    if (loadingToGame) {
      goto(`/game/${lastPlayerGameValue}`)
    }
  }

  async function createGame() {
    const account = burnerManager.getActiveAccount()
    if (account) {
      await client.start.create({ account, map_id: $selectedMap })
      loadingToGame = true
    } else {
      console.error('No active account found')
    }
  }
</script>

<div class="map-grid">
  {#each maps as map}
    <div class="mini-map-container">
      <MiniMap {map} />
    </div>
  {/each}
</div>

<div class="flex justify-end p-4 fixed bottom-0 right-0">
  <button
    class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
    on:click={createGame}
  >
    Create Game
  </button>
</div>

<style>
  .map-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 16px;
    padding: 16px;
  }

  .mini-map-container {
    width: 300px;
    height: 300px;
    border: 1px solid #ccc;
    border-radius: 8px;
    overflow: hidden;
    background-color: #f0f0f0;
  }

  .flex {
    display: flex;
  }

  .justify-end {
    justify-content: flex-end;
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

  .right-0 {
    right: 0;
  }

  button {
    cursor: pointer;
  }
</style>
