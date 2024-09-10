<script lang="ts">
    import Splitscreen from './Cameras/SplitScreen.svelte';
    import BirdView from './Cameras/BirdView.svelte';
    import { birdView } from '$stores/cameraStores';
    import FirstPerson  from './Cameras/FirstPerson.svelte';
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