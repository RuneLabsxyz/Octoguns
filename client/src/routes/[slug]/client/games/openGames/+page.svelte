<script lang="ts">
  import { run } from 'svelte/legacy'

  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn
  import { goToSession, joinSession } from '$lib/game'
  import { account } from '$stores/account'
  import { env } from '$stores/network'
  import { openSessions } from '$lib/api/sessions'
  import { type Session } from '$src/dojo/models.gen'

  let availableSessions: Session[] | null = $state(null)
  let currentSessions: any = $state(null)
  let playerEntity: Entity = $state()

  openSessions.subscribe((sessions) => {
    availableSessions = sessions
  })
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
