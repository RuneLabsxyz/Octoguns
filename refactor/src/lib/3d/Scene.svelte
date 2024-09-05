<script lang="ts">
    import { T, useTask, useThrelte } from '@threlte/core';
    import { onDestroy, onMount } from 'svelte';
    import Map from './Map.svelte';
    import Cameras from './Cameras.svelte';
    import Characters from './Characters.svelte';
    import { recordingMode, keyStateStore, isMouseDownStore } from '../../stores/gameStores';
    import {handleKeyDown, handleKeyUp, handleMouseDown, handleMouseUp} from "$lib/handlers"

    let {renderer, scene} = useThrelte();

    onMount(() => {
        window.addEventListener('keydown', handleKeyDown);
        window.addEventListener('keyup', handleKeyUp);
        window.addEventListener('mousedown', handleMouseDown);
        window.addEventListener('mouseup', handleMouseUp);
    });

    onDestroy(() => {
        window.removeEventListener('keydown', handleKeyDown);
        window.removeEventListener('keyup', handleKeyUp);
        window.removeEventListener('mousedown', handleMouseDown);
        window.removeEventListener('mouseup', handleMouseUp);
        renderer.setAnimationLoop(null);
    });

    const updateLogic = () => {
        console.log($keyStateStore);
    }
    

    useTask( (delta) => {
        console.log(delta);

        updateLogic();
        //renderCameras()

    })

</script>

<T.Group>
    <Cameras />
    <Map />
    <Characters />
</T.Group>
