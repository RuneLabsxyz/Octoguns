<script lang="ts">
    import { derived } from "svelte/store";
    import { setupStore } from "../../stores/dojoStore";
    import { createComponentValueStore } from "../../dojo/componentValueStore";
    import GameList from "$lib/games/GameList.svelte";

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore);

    $: account = burnerManager.getActiveAccount();

	$: globalentity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(0).toString()])
		: undefined
	);

	$: playerEntity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([account?.address])
		: undefined
	);

	$: global = createComponentValueStore(clientComponents.Global, globalentity);
	$: player = createComponentValueStore(clientComponents.Player, playerEntity);
    
</script>


<div>
    GAMES
</div>


{#if $global}
    <div class="flex justify-center items-center">
        <GameList {global} />
    </div>

    <button
        on:click={async () => {
        const account = burnerManager.getActiveAccount();
        if (account) {
            await client.start.create({ account });
        } else {
            console.error("No active account found");
        }
    }}>Create Game</button>

{/if}




