<script lang="ts">
    import { setupStore } from "../../stores/dojoStore";


    $: ({ clientComponents, torii, burnerManager, client } = $setupStore as any);

    export let availableSessions;

    $: pendingSessions = availableSessions;

    $: account = burnerManager.getActiveAccount();


	async function joinSession(session: any) {
		if (account) {
			console.log("Joining session", session.value);
			await client.start.join({ account: account, session_id: session.value });
			window.location.href = `/game/${session.value}`;
		} else {
			console.error("No active account found");
		}
	}
</script>
<div class="flex flex-col items-center text-center">
    <h1 class="font-Block text-6xl py-10">Octo Guns</h1>
    <div class="w-full max-w-3xl border-2 border-black p-4 overflow-y-auto" style="max-height: 75vh;">
    {#if pendingSessions}
            {#each availableSessions.slice().reverse() as session}
                <div class="flex justify-between items-center py-2">
                    <p class="flex-grow text-left">{session.value}</p>
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
