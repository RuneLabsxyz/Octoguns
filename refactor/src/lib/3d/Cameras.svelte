<script lang="ts">
    import Splitscreen from './Cameras/SplitScreen.svelte';
    import BirdView from './Cameras/BirdView.svelte';
    // TEMPORARY
    let birdView: boolean = true;
</script>

{#if birdView}
    <BirdView />
{:else}
    <Splitscreen />
{/if}