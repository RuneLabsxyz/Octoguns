<script lang="ts">
    import { derived } from "svelte/store";
    import { setupStore } from "../../stores/dojoStore";
    import { createComponentValueStore } from "../../dojo/componentValueStore";
    import GameList from "$lib/games/GameList.svelte";

    let availableSessions: any = null;

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore as any);

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

    //Filter out the sessions that the player is already in
	$: if ($global) {
		if ($player) {
			console.log("player", $player);
			let playerGames = new Set($player.games.map(game => game.value));
			availableSessions = $global.pending_sessions.filter(session => !playerGames.has(session.value));
		} else {
			availableSessions = $global.pending_sessions;
		}
	}
</script>


    <div class="flex justify-center items-center">
        {#if availableSessions}
            <GameList {availableSessions} />
        {/if}
    </div>

    <div class="flex justify-between">
        <button
            class="ml-4 px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-700 transition"
            on:click={() => {
                // Add your back button logic here
                console.log("Back button clicked");
            }}>Back</button>
        <button
            class="mr-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
            on:click={async () => {
            const account = burnerManager.getActiveAccount();
            if (account) {
                await client.start.create({ account });
            } else {
                console.error("No active account found");
            }
        }}>Create Game</button>
    </div>





