<script lang="ts">
 import { setupStore, move_over, current_session_id, pending_moves } from "src/stores";
    import { derived } from "svelte/store";


	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);


</script>


{#if $move_over}
  <div class="end-turn-container">
    <button
      class="end-turn-button"
      on:click={() => {
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