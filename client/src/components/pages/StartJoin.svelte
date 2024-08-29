<script lang="ts">
	import { createComponentValueStore } from "../../dojo/componentValueStore";
	import { setupStore } from "../../main";
    import { derived, writable } from "svelte/store";

	//TODO: Check if games are created by the current user
	//TODO: route if the user creates or

	//TODO: Check if games are created by the current user
	//TODO: route if the user creates or

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Global, entity);

	// Add this function to handle joining a session
	async function joinSession(session) {
		const account = burnerManager.getActiveAccount();
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
	  {#each $global.pending_sessions.slice().reverse() as session}
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
  