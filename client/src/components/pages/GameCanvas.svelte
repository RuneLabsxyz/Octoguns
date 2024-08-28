<script lang="ts">
    import { Canvas } from "@threlte/core"
    import Game from '../Game.svelte'    
    import {move_over, pending_moves} from "src/stores";
    import { setupStore } from "src/main";
    let {client, burnerManager} = $setupStore;

</script>

<div class="container">
    <Canvas>
            <Game />
    </Canvas>
</div>
{#if $move_over}
  <div class="over-container">
    <button
      class="over-button"
      on:click={() => client.spawn.spawn({account: burnerManager.account, 
                                            session_id: 0})}
    >
      Start Game
    </button>
    <button
      class="over-button"
      on:click={() => client.actions.move({account: burnerManager.account, 
                                            session_id: 0, 
                                            moves: $pending_moves})}
    >
      End Turn
    </button>
  </div>
{/if}

<style>
    .container {
        display: flex;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
    }

    :global(canvas) {
        width: 100%;
        height: 100%;
        display: block;
        cursor: pointer; /* Added line */
    }

    button {
        font-size: 1em;
        padding: 10px;
        margin-top: 8%;
    }
</style>