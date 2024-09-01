<script lang="ts">
    import { goto } from '$app/navigation';
    import { isSetup } from '../stores/dojoStore';

    $: console.log($isSetup);

</script>


<div class="flex flex-col justify-center items-center h-screen">
    <div class="text-9xl">
        <h1 class="font-Block">OCTO</h1>
        <h2 class="font-Block">GUNS</h2>
    </div>
    {#if $isSetup}
        <button class="p-5 pt-20" on:click={() => goto('/games')}>
            Play
        </button>
    {:else}
        <button class="p-5 pt-20" disabled>
            Sorry we are having issues with torii
        </button>
    {/if}
</div>
