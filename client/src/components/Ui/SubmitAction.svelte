<script lang="ts">
    import { setupStore, move_over, current_session_id, pending_moves } from "src/stores";
    import { derived } from "svelte/store";
    import { createComponentValueStore } from "src/dojo/componentValueStore";

	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);
    $: entity = derived(setupStore, ($store) =>
        $store
        ? torii.poseidonHash([BigInt($current_session_id).toString()])
        : undefined
    );

    $: sessionMeta = createComponentValueStore(clientComponents.SessionMeta, entity);
    $: console.log("SessionMeta", $sessionMeta);
</script>


{#if $move_over}
  <div class="end-turn-container">
    <button
      class="end-turn-button"
      on:click={() => {
        console.log($pending_moves);
        const account = burnerManager.getActiveAccount();
        client.actions.move({account: account, 
                                            session_id: $current_session_id, 
                                            moves: $pending_moves})
        }}
    >
      End Turn
    </button>
  </div>
{/if}

<style>
  .end-turn-container {
    position: absolute;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1001;
  }

  .end-turn-button {
    padding: 10px 20px;
    font-size: 16px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
</style>