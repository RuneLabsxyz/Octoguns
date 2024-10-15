<script lang="ts">
  import { dojoStore } from '$stores/dojoStore';
  import { componentValueStore } from '$dojo/componentValueStore';
  import GameList from '$lib/games/GameList.svelte';
  import { type Entity } from '@dojoengine/recs';
  import Button from '$lib/ui/Button.svelte';
  import { cn } from '$lib/css/cn';
  import { joinSession } from '$lib/game';
  import { account } from '$stores/account';
  import { env } from '$stores/network';

  type Session = {
    value: any;
    isYourTurn: boolean;
    isStarted: boolean;
    isFinished: boolean;
    enemy: string;
  };

  let sessions: Session[] = [];
  let playerEntity: Entity;

  $: ({ clientComponents, torii } = $dojoStore as any);

  $: globalEntity = torii.poseidonHash([BigInt(0).toString()]);

  $: if ($account) playerEntity = torii.poseidonHash([$account.address]);

  $: global = componentValueStore(clientComponents.Global, globalEntity);
  $: player = componentValueStore(clientComponents.Player, playerEntity);

  function compressAddress(address: string): string {
    if (!address) return 'Not available';
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  }

  $: if ($global) {
    let currentSessions = [];
    let availableSessions = [];

    if ($player) {
      // Get the games the player is already in
      currentSessions = $player.games.map((game: { value: any }) => game.value);

      const playerGamesSet = new Set(currentSessions);

      // Filter out the sessions the player is already in
      availableSessions = $global.pending_sessions.filter(
        (session: { value: any }) => !playerGamesSet.has(session.value)
      );
    } else {
      availableSessions = $global.pending_sessions;
    }

    sessions = [];

    for (const session of availableSessions) {
      const sessionEntity = torii.poseidonHash([BigInt(session.value).toString()]);

      if (sessionEntity) {
        const sessionDataStore = componentValueStore(clientComponents.Session, sessionEntity);
        const sessionMetaDataStore = componentValueStore(clientComponents.SessionMeta, sessionEntity);

        sessionDataStore.subscribe((data) => {
          if (data) {
            const enemyAddress = `0x${BigInt(data.player1).toString(16)}`;
            const newSession: Session = {
              value: session.value,
              isYourTurn: false, 
              isStarted: false, 
              isFinished: data.state === 3,
              enemy: compressAddress(enemyAddress),
            };

            sessionMetaDataStore.subscribe((metaData) => {
              if (metaData) {
                newSession.isStarted = metaData.p1_character !== 0;
              }
            });

            sessions = [...sessions, newSession];
          }
        });
      }
    }
  }
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Public games</h1>
    <span class="flex-grow"></span>
    <Button href={`/${$env}/client/games/create`}>+ New Game</Button>
  </div>
  <div class={cn('flex flex-col', { 'justify-center': sessions.length === 0 })}>
    {#if sessions && sessions.length > 0}
      <h1 class="text-xl ml-5 mb-3 font-bold">Games available</h1>
      <GameList
        availableSessions={sessions}
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
