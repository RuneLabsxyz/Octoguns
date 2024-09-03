<script lang="ts">
    export let global;

    $: pendingSessions = $global.pending_sessions;

    async function joinSession(session: any) {
        console.log(`Joining session: ${session.value}`);
    }
</script>

<div class="flex flex-col items-center h-screen text-center">
    <h1 class="font-Block text-6xl py-10">Octo Guns</h1>

    {#if pendingSessions}
        <div class="w-full max-w-3xl border-2 border-black p-4 overflow-y-auto">
            {#each pendingSessions as session}
                <div class="flex justify-between items-center py-2">
                    <p class="flex-grow text-left">{session.value}</p>
                    <button 
                        class="ml-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
                        on:click={() => joinSession(session)}>
                        Join
                    </button>
                </div>
            {/each}
        </div>
    {/if}
</div>
