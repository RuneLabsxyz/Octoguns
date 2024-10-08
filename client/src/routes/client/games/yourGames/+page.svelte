<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn'
  import { goToSession, joinSession } from '$lib/game'
  import { account } from '$stores/account'

  let availableSessions: any = null
  let currentSessions: any = null
  let playerEntity: Entity
  let finishedSessions: any = null
  let activeSessions: any = null

  $: ({ clientComponents, torii, client } = $dojoStore as any)


  $: globalentity = torii.poseidonHash([BigInt(0).toString()])

  $: if ($account) playerEntity = torii.poseidonHash([$account?.address])

  $: global = componentValueStore(clientComponents.Global, globalentity)
  $: player = componentValueStore(clientComponents.Player, playerEntity)

  $: if ($global) {
    if ($player) {
      console.log('player', $player)
      currentSessions = $player.games.map((game: { value: any }) => game.value)

      let playerGames = new Set(currentSessions)

      currentSessions = currentSessions.map((e: any) => ({ value: e }))

      availableSessions = $global.pending_sessions.filter(
        (session: { value: unknown }) => !playerGames.has(session.value)
      )

      
      for (let i = 0; i < currentSessions.length; i++) {
        let sessionEntity = torii.poseidonHash([BigInt(currentSessions[i].value).toString()]);
        if (sessionEntity) {
          let sessionDataStore = componentValueStore(clientComponents.Session, sessionEntity);
          sessionDataStore.subscribe((data) => {
            if (data) {
              console.log('sessionData', data);
            } else {
              console.log('No session data for entity:', sessionEntity);
            }
          });
        }
      }


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
    <h1 class="text-3xl font-bold">Play</h1>
    <span class="flex-grow"></span>
    <Button href="/client/games/create">+ New Game</Button>
  </div>
  <div class="overflow-y-auto overflow-x-clip h-full">
    {#if currentSessions && currentSessions.length > 0}
      <div class="pb-5 border-b-2 mb-5 border-gray-800">
        <h1 class="text-xl ml-5 mb-3 font-bold">Your active games</h1>
        <GameList
          availableSessions={currentSessions}
          on:select={(session) => goToSession(session.detail)}
        />
      </div>
    {/if}

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
          <Button href="/client/games/create">+ New Game</Button>
        </div>
      {/if}
    </div>
  </div>
</div>
