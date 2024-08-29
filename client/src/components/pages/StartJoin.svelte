<script lang="ts">
  import { Account } from "@dojoengine/torii-wasm";
	import { createComponentValueStore } from "../../dojo/componentValueStore";
	import { setupStore } from "src/stores";
    import { derived, writable } from "svelte/store";
	import { onMount } from 'svelte';
	import { availableSessions, mySessions } from "src/stores";

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: account = burnerManager.getActiveAccount();

	$: entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: entity2 = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([account?.address])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Global, entity);
	$: player = createComponentValueStore(clientComponents.Player, entity2);

	$: console.log("Player", $player);

	onMount(() => {
		if ($global && $player) {
			const playerGames = new Set($player.games.map(game => game.value));
			
			$availableSessions = $global.pending_sessions.filter(session => !playerGames.has(session.value));
			$mySessions = $global.pending_sessions.filter(session => playerGames.has(session.value));
		}
	});

	$: if ($global && $player) {
		const playerGames = new Set($player.games.map(game => game.value));
		
		availableSessions.set($global.pending_sessions.filter(session => !playerGames.has(session.value)));
		mySessions.set($global.pending_sessions.filter(session => playerGames.has(session.value)));
	}

	$: console.log("Available sessions", $mySessions);
	// Add this function to handle joining a session
	async function joinSession(session) {
		if (account) {
			console.log("Joining session", session.value);
			await client.start.join({ account: account, session_id: session.value });
			window.location.href = "/game";
		} else {
			console.error("No active account found");
		}
	}
</script>
  
  <div class="higher">
	<h1>Octo Guns</h1>
  
	{#if !$setupStore}
	  <p>Setting up...</p>
	{/if}
  
	<div class="session-list">
		{#if $global}
	  {#each $availableSessions.slice().reverse() as session}
		  <div class="session-item">
			  <p>{session.value}</p>
			  <button on:click={() => joinSession(session)}>Join</button>
		  </div>
	  {/each}
	  {/if}
	</div>
  
	<div class="buttons">
	  <button
 		on:click={() => {window.location.href = '/';}}>Back</button>
 
	  <button
		on:click={async () => {
		  const account = burnerManager.getActiveAccount();
		  if (account) {
			await client.start.create({ account });
			window.location.href = "/game";
		  } else {
			console.error("No active account found");
		  }
		}}>Create Game</button>
	</div>
</div>
  
  <style>
	.higher {
	  display: flex;
	  flex-direction: column;
	  justify-content: center;
	  align-items: center;
	  height: 100vh;
	  text-align: center;
	}

	h1 {
		font-family: 'Block';
        font-size: 5em;
		padding: 60px;
        line-height: 0.8;
        margin-bottom: -0.1em;
    }


	.session-list {
	  flex: 1;
	  display: flex;
	  flex-direction: column;
	  justify-content: flex-start;
	  align-items: stretch;
	  border: 2px solid #000;
	  padding: 1rem;
	  margin-bottom: 1rem;
	  max-width: 80%;
	  min-width: 40%;
	  width: auto;
	  max-height: 60%;
	  overflow-y: auto;
	}
  
	.session-item {
	  margin: 0.5rem 0;
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  width: 100%;
	  padding: 0.5rem;
	}
  
	.session-item p {
	  margin: 0;
	  flex-grow: 1;
	  text-align: left;
	}
  
	.session-item button {
	  margin-left: 1rem;
	  white-space: nowrap;
	}
  
	.buttons {
	  display: flex;
	  justify-content: space-between;
	  width: 80%;
	}
  
	button {
	  padding: 0.5rem 1rem;
	  font-size: 1rem;
	}
  </style>
  