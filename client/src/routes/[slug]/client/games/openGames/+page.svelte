<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore, type ComponentStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn'
  import { goToSession, joinSession } from '$lib/game'
  import { account } from '$stores/account'
  import { env } from '$stores/network';

  let availableSessions: any = null
  let currentSessions: any = null
  let playerEntity: Entity
  let clientComponents: any
  let torii: any
  let client: any
  let globalentity: any
  let global: ComponentStore
  let player: ComponentStore

  $: if ($dojoStore) ({ clientComponents, torii, client } = $dojoStore as any)


  $: if (torii) globalentity = torii.poseidonHash([BigInt(0).toString()])

  $: if ($account && torii) playerEntity = torii.poseidonHash([$account?.address])

  $: if (clientComponents) global = componentValueStore(clientComponents.Global, globalentity)
  $: if (clientComponents) player = componentValueStore(clientComponents.Player, playerEntity)

  $: if ($global) {
    if ($player) {
      console.log('player', $player)
      currentSessions = $player.games.map((game: { value: any }) => game.value)

      let playerGames = new Set(currentSessions)

      currentSessions = currentSessions.map((e: any) => ({ value: e }))

      availableSessions = $global.pending_sessions.filter(
        (session: { value: unknown }) => !playerGames.has(session.value)
      )

      console.log('currentSessions', currentSessions, currentSessions.length)
      console.log(
        'availableSessions',
        availableSessions,
        availableSessions.length
      )
    } else {
      availableSessions = $global.pending_sessions
    }
  }
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Public games</h1>
    <span class="flex-grow"></span>
    <Button href={`/${$env}/client/games/create`}>+ New Game</Button>
  </div>
    <div
      class={cn('flex flex-col', {
        'justify-center': !availableSessions,
      })}
    >
      {#if availableSessions && availableSessions.length > 0}
        <h1 class="text-xl ml-5 mb-3 font-bold">Games available</h1>
        <GameList
          {availableSessions}
          on:select={(session) => joinSession(session.detail)}
        />
      {:else}
        <div class="self-center align-middle flex flex-col gap-2">
          <p>No games are currently available.</p>
          <Button href={`/${$env}/client/games/create`}>+ New Game</Button>
        </div>
      {/if}
    </div>
  </div>
