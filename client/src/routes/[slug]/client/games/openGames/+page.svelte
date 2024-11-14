<script lang="ts">
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn'
  import { env } from '$stores/network'
  import { openSessions } from '$lib/api/sessions'
  import { openSessionMetas } from '$lib/api/sessionMeta'
  import type { Session, SessionMeta } from '$src/dojo/models.gen'

  // TODO: Migrate this to directly using stores

  let availableSessions: Session[] | null = $derived($openSessions)
  let availableSessionMetas: SessionMeta[] | null = $derived($openSessionMetas)

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
        {availableSessionMetas}
        contractCall={true}
      />
    {:else}
      <div class="self-center align-middle flex flex-col gap-2">
        <p>No games are currently available.</p>
        <Button href={`/${$env}/client/games/create`}>+ New Game</Button>
      </div>
    {/if}
  </div>
</div>
