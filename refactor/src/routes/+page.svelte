<script lang="ts">
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';

</script>


<div class="flex flex-col justify-center items-center h-screen">
    <div class="text-9xl">
        <h1 class="font-Block">OCTO</h1>
        <h2 class="font-Block">GUNS</h2>
    </div>
    <button class="p-5 pt-20" on:click={() => goto('/games')}>
        Play
    </button>
</div>

