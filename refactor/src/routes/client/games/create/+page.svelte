<script lang="ts">
  import { accountStore, dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { goto } from '$app/navigation'
  import { type Entity } from '@dojoengine/recs'

  let loadingToGame = false
  let playerEntity: Entity

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any)

  $: account = $accountStore

  $: if ($accountStore) playerEntity = torii.poseidonHash([account?.address])

  $: player = componentValueStore(clientComponents.Player, playerEntity)

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
      await client.start.create({ account, map_id: 0 })
      loadingToGame = true
    } else {
      console.error('No active account found')
    }
  }
</script>

<div class="flex justify-end p-4 fixed bottom-0 right-0">
  <button
    class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
    on:click={createGame}
  >
    Create Game
  </button>
</div>
