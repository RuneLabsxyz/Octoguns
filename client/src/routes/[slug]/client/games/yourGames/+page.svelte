<script lang="ts">
  import { run } from 'svelte/legacy'

  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import GameList from '$lib/games/GameList.svelte'
  import { type Entity } from '@dojoengine/recs'
  import Button from '$lib/ui/Button.svelte'
  import { cn } from '$lib/css/cn'
  import { goToSession } from '$lib/game'
  import { account } from '$stores/account'
  import { areAddressesEqual } from '$lib/helper'
  import { env } from '$stores/network'
  import {
    yourActiveSessions,
    yourFinishedSessions,
    yourSessions,
    yourUnstartedSessions,
  } from '$lib/api/sessions'
  import {
    yourSessionMetas,
    yourFinishedSessionsMetas,
    yourActiveSessionMetas,
    yourUnstartedSessionsMetas,
  } from '$lib/api/sessionMeta'
  import type { Session, SessionMeta } from '$src/dojo/models.gen'

  // session data
  let activeSessions: Session[] | null = $derived($yourActiveSessions)
  let unstartedSessions: Session[] | null = $derived($yourUnstartedSessions)
  let finishedSessions: Session[] | null = $derived($yourFinishedSessions)
  let sessions: Session[] | null = $derived($yourSessions)

  //session metas data
  let activeSessionMetas: SessionMeta[] | null = $derived(
    $yourActiveSessionMetas
  )
  let unstartedSessionsMetas: SessionMeta[] | null = $derived(
    $yourUnstartedSessionsMetas
  )
  let finishedSessionMetas: SessionMeta[] | null = $derived(
    $yourFinishedSessionsMetas
  )
  let sessionMetas: SessionMeta[] | null = $derived($yourSessionMetas)

  console.log(activeSessions)
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Your games</h1>
    <span class="flex-grow"></span>
    <Button href={`/${$env}/client/games/create`}>+ New Game</Button>
  </div>
  <div class="overflow-y-auto overflow-x-clip h-full">
    <div class="pb-5 border-b-2 mb-5 border-gray-800">
      <h1 class="text-xl ml-5 mb-3 font-bold">Your active games</h1>
      <GameList
        availableSessions={activeSessions}
        availableSessionMetas={activeSessionMetas}
        contractCall={false}
        on:select={(session) => goToSession(session.detail)}
      />
    </div>

    <div class="pb-5 border-b-2 mb-5 border-gray-800">
      <h1 class="text-xl ml-5 mb-3 font-bold">Your not started games</h1>
      <GameList
        availableSessions={unstartedSessions}
        availableSessionMetas={unstartedSessionsMetas}
        contractCall={false}
        on:select={(session) => goToSession(session.detail)}
      />
    </div>

    <div class="pb-5">
      <h1 class="text-xl ml-5 mb-3 font-bold">Your finished games</h1>
      <GameList
        availableSessions={finishedSessions}
        availableSessionMetas={finishedSessionMetas}
        contractCall={false}
        on:select={(session) => goToSession(session.detail)}
      />
    </div>
  </div>
</div>
