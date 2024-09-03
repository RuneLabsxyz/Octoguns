<script lang="ts">
    import { gameState, sessionId } from "../../stores/gameStores";
    import { setupStore } from "../../stores/dojoStore";

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore as any);

    $: account = burnerManager.getActiveAccount();

    function spawn() {
        if (account) {
            client.spawn.spawn({ account: account, session_id: $sessionId });
        }
    }
</script>

<div class="flex justify-center items-center h-screen">
    {#if $gameState == 0}
        <h1 class="text-4xl font-bold">Waiting for another player</h1>
    {:else if $gameState == 1}
        <button 
            class="ml-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
            on:click={spawn}
        >
            Spawn characters
        </button>
    {/if}
</div>
