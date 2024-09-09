<script lang="ts">
    import Splitscreen from './cameras/SplitScreen.svelte';
    import BirdView from './cameras/BirdView.svelte';
    import { birdView } from '../../../stores/cameraStores';
    import FirstPerson  from './cameras/FirstPerson.svelte';
    import { PerspectiveCamera } from 'three';

    let birdViewValue: boolean;

    $: birdViewValue = $birdView
</script>

{#if birdViewValue}
    <BirdView />    
{/if}
{#if !birdViewValue}
    <PerspectiveCamera />
        <FirstPerson />
    <PerspectiveCamera />
{/if}