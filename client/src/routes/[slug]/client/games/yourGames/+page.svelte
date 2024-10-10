<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn'
  import { goToSession } from '$lib/game'
  import { account } from '$stores/account'
  import { areAddressesEqual } from '$lib/helper'

  type Session = {
    value: any;
    isYourTurn: boolean;
    isStarted: boolean;
    isFinished: boolean;
  };

  let playerEntity: Entity
  let sessions: Session[] = []

  $: ({ clientComponents, torii } = $dojoStore as any)
  $: if ($account) playerEntity = torii.poseidonHash([$account?.address])
  $: player = componentValueStore(clientComponents.Player, playerEntity)
  $: console.log('sessions', sessions)

  $: if ($player && $account?.address) {
    const currentSessions = $player.games.map((game: { value: any }) => ({ value: game.value }))
    sessions = []

    for (const session of currentSessions) {
      const sessionEntity = torii.poseidonHash([BigInt(session.value).toString()])
      if (sessionEntity) {
        const sessionDataStore = componentValueStore(clientComponents.Session, sessionEntity)
        const sessionMetaDataStore = componentValueStore(clientComponents.SessionMeta, sessionEntity)
        
        sessionDataStore.subscribe((data) => {
          if (data) {
            const newSession: Session = {
              value: session.value,
              isYourTurn: false,
              isStarted: false,
              isFinished: data.state === 3
            }
            sessionMetaDataStore.subscribe((metaData) => {
              if (metaData) {
                newSession.isStarted = metaData.p1_character !== 0
                const currentPlayerId = areAddressesEqual(data.player1, $account.address) ? 1 : 2
                newSession.isYourTurn = 
                  (currentPlayerId === 1 && metaData.turn_count % 2 === 0) ||
                  (currentPlayerId === 2 && metaData.turn_count % 2 === 1)
              }
            })
            sessions = [...sessions, newSession]
          }
        })
      }
    }
  }
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Your games</h1>
    <span class="flex-grow"></span>
    <Button href="/client/games/create">+ New Game</Button>
  </div>
  <div class="overflow-y-auto overflow-x-clip h-full">
    {#if sessions.some(s => !s.isFinished && s.isStarted)}
      <div class="pb-5 border-b-2 mb-5 border-gray-800">
        <h1 class="text-xl ml-5 mb-3 font-bold">Your active games</h1>
        <GameList
          availableSessions={sessions.filter(s => !s.isFinished && s.isStarted)}
          on:select={(session) => goToSession(session.detail)}
        />
      </div>
    {/if}
    
    {#if sessions.some(s => !s.isFinished && !s.isStarted)}
      <div class="pb-5 border-b-2 mb-5 border-gray-800">
        <h1 class="text-xl ml-5 mb-3 font-bold">Your not started games</h1>
        <GameList
          availableSessions={sessions.filter(s => !s.isFinished && !s.isStarted)}
          on:select={(session) => goToSession(session.detail)}
        />
      </div>
    {/if}
    
    {#if sessions.some(s => s.isFinished)}
      <div class="pb-5">
        <h1 class="text-xl ml-5 mb-3 font-bold">Your finished games</h1>
        <GameList
          availableSessions={sessions.filter(s => s.isFinished)}
          on:select={(session) => goToSession(session.detail)}
        />
      </div>
    {/if}
  </div>
</div>
