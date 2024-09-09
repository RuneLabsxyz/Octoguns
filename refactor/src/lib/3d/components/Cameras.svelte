<script lang="ts">
    import Splitscreen from './cameras/SplitScreen.svelte';
    import BirdView from './cameras/BirdView.svelte';
    import { birdView } from '../../../stores/cameraStores';

    let birdViewValue: boolean;

    $: birdViewValue = $birdView
</script>

{#if birdViewValue}
    <BirdView />    
{/if}
{#if !birdViewValue}
    <Splitscreen />
{/if}