<script lang="ts">
    import { T, useTask, useThrelte } from '@threlte/core';
    import { Vector3 } from 'three';
    import { onDestroy, onMount } from 'svelte';
    import Map from './Map.svelte';
    import Cameras from './Cameras.svelte';
    import Characters from './Characters.svelte';
    import { recordingMode, replayMode, keyStateStore, isMouseDownStore, recordedMove, frameCounter } from '../../stores/gameStores';
    import {handleKeyDown, handleKeyUp, handleMouseDown, handleMouseUp} from "$lib/handlers"
    import type { TurnData } from '../../stores/gameStores';
    import { truncateToDecimals } from '$lib/helper.';

    let {renderer, scene, camera} = useThrelte();

    let frame_counter = 0;
    let move_speed = 1;
    const moveDirection = new Vector3();


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

    const recordMove = () => {
        console.log($recordedMove + " at frame: " + frame_counter);
        if ($keyStateStore.forward) moveDirection.z -= 1;
        if ($keyStateStore.backward) moveDirection.z += 1;
        if ($keyStateStore.left) moveDirection.x -= 1;
        if ($keyStateStore.right) moveDirection.x += 1;

        // Check if there's any movement or if the mouse is down (indicating a potential shooting action)
        if (moveDirection.length() > 0 || $isMouseDownStore) {
            moveDirection.normalize().multiplyScalar(move_speed);
            moveDirection.applyQuaternion($camera.quaternion);
            moveDirection.x = truncateToDecimals(moveDirection.x, 2);
            moveDirection.z = truncateToDecimals(moveDirection.z, 2);
            moveDirection.y = 0;

            $camera.position.add(moveDirection);

            let move = {
                x: Math.abs(Math.round(moveDirection.x * 100)),
                y: Math.abs(Math.round(moveDirection.z * 100)),
                xdir: moveDirection.x >= 0,
                ydir: moveDirection.z >= 0,
            };
            $recordedMove.sub_moves.push(move);

        }

    }

    const replayMove = (move: TurnData) => {

    }

    useTask( (delta) => {
        console.log(delta);

        if (frame_counter % 3 ==0) {
            if ($recordingMode) {
                recordMove();
            }
            if ($replayMode) {
                replayMove($recordedMove);
            }
        }

        //renderCameras()
        frame_counter+=1;
    })

</script>

<T.Group>
    <Cameras />
    <Map />
    <Characters />
</T.Group>
