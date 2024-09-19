<script lang="ts">
  import { accountStore, dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { goto } from '$app/navigation'
  import { type Entity } from '@dojoengine/recs'

  let availableSessions: any = null
  let playerEntity: Entity

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any)

  $: account = $accountStore

  $: globalentity = torii.poseidonHash([BigInt(0).toString()])

  $: if ($accountStore) playerEntity = torii.poseidonHash([account?.address])

  $: global = componentValueStore(clientComponents.Global, globalentity)
  $: player = componentValueStore(clientComponents.Player, playerEntity)

  $: if ($global) {
    if ($player) {
      console.log('player', $player)
      let playerGames = new Set(
        $player.games.map((game: { value: any }) => game.value)
      )
      availableSessions = $global.pending_sessions.filter(
        (session: { value: unknown }) => !playerGames.has(session.value)
      )
    } else {
      availableSessions = $global.pending_sessions
    }
  }
</script>

<div class="flex flex-col h-screen">
  <div class="flex justify-center items-center">
    <div class="w-3/4 h-full overflow-auto">
      {#if availableSessions}
        <GameList {availableSessions} />
      {/if}
    </div>
  </div>

  <div class="flex justify-between p-4 fixed bottom-0 left-0 right-0 bg-white">
    <button
      class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-700 transition"
      on:click={() => {
        window.location.href = '/'
      }}>Back</button
    >
    <button
      class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
      on:click={() => {
        goto('/client/games/create')
      }}>Create Game</button
    >
  </div>
</div>
