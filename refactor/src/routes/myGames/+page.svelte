<script lang="ts">
     import { derived } from "svelte/store";
    import { dojoStore } from "../../stores/dojoStore";
    import { componentValueStore } from "../../dojo/componentValueStore";
    import { goto } from "$app/navigation";

    let availableSessions: any = null;
    $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any);

    $: account = burnerManager.getActiveAccount();

	let playerEntity = torii.poseidonHash([account?.address])

	$: player = componentValueStore(clientComponents.Player, playerEntity);

    $: if ($player) {
        let playerGames = new Set($player.games.map((game: { value: any; }) => game.value));
        availableSessions = playerGames;
    }

    function joinSession(session: number) {
        goto(`/game/${session}`);
    }

</script>

<div class="flex flex-col items-center text-center">
    <h1 class="font-Block text-6xl py-10">my games</h1>
    <div class="w-full max-w-3xl border-2 border-black p-4 overflow-y-auto" style="max-height: 75vh;">
    {#if availableSessions}
            {#each availableSessions as session}
                <div class="flex justify-between items-center py-2">
                    <p class="flex-grow text-left">{session}</p>
                    <button 
                        class="ml-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
                        on:click={() => joinSession(session)}>
                        Join
                    </button>
                </div>
            {/each}
        {/if}
    </div>
</div>
