<script lang="ts">
	import SceneCanvas from "../../components/SceneCanvas.svelte";
    import { Canvas } from "@threlte/core";
    import { createComponentValueStore } from "src/dojo/componentValueStore";
    import { setupStore } from "src/main";
    import { derived, writable } from "svelte/store";
    import { current_session_id } from "src/stores";
    import Ui from "./Ui.svelte";
    import {move_over, pending_moves} from "src/stores";

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore);

    $: account = burnerManager.getActiveAccount();
    $: entity = derived(setupStore, ($store) =>
        $store
        ? torii.poseidonHash([account?.address])
        : undefined
    );

    $: player = createComponentValueStore(clientComponents.Player, entity);

    $: highestIndexedGameValue = $player.games.length > 0 
        ? $player.games[$player.games.length - 1].value 
        : undefined;
       
    $: current_session_id.set(highestIndexedGameValue);

    const gameStarted = writable(false);

    function startGame() {
        const account = burnerManager.getActiveAccount();
        if (account) {
            client.spawn.spawn({ account: account, session_id: $current_session_id });
            gameStarted.set(true);
        } else {
            console.error("No active account found");
        }
    }
</script>

<Ui />
<div class="container">
    <Canvas>
        <SceneCanvas />
    </Canvas>
    {#if !$gameStarted}
        <button class="start-button" on:click={startGame}>Start Game</button>
    {/if}
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
    }

    .start-button {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        padding: 10px 20px;
        font-size: 18px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        z-index: 10;
    }
</style>