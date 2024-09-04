<script lang="ts">
    import { derived } from "svelte/store";
    import { accountStore, dojoStore } from "../../stores/dojoStore";
    import { componentValueStore } from "../../dojo/componentValueStore";
    import GameList from "$lib/games/GameList.svelte";
    import { goto } from "$app/navigation";

    let availableSessions: any = null;
    let loadingToGame = false; // TODO add loading thingy
    let playerEntity: Entity;

    $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any);

    $: account = $accountStore;

	$: globalentity = torii.poseidonHash([BigInt(0).toString()])

	$: if ($accountStore) playerEntity = torii.poseidonHash([account?.address])

	$: global = componentValueStore(clientComponents.Global, globalentity);
	$: player = componentValueStore(clientComponents.Player, playerEntity);

	$: if ($global) {
		if ($player) {
			console.log("player", $player);
			let playerGames = new Set($player.games.map((game: { value: any; }) => game.value));
			availableSessions = $global.pending_sessions.filter((session: { value: unknown; }) => !playerGames.has(session.value));
		} else {
			availableSessions = $global.pending_sessions;
		}
	}

    // Listen for player update to route to game page
    $: if ($player) {
        let lastPlayerGameValue = $player.games.length > 0 ? $player.games[$player.games.length - 1].value : null;
        startSession(lastPlayerGameValue);
    }

    function startSession(lastPlayerGameValue: number) {
        if (loadingToGame) {
            goto(`/game/${lastPlayerGameValue}`)
        }
    }

    async function createGame() {
        const account = burnerManager.getActiveAccount();
        if (account) {
            await client.start.create({ account });
            loadingToGame = true;
            
        } else {
            console.error("No active account found");
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
                window.location.href = "/";
            }}>Back</button>
        <button
            class="mr-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
            on:click={createGame}>Create Game</button>
    </div>





