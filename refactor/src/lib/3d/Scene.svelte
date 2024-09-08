<script lang="ts">
    import { T, useTask, useThrelte } from '@threlte/core';
    import { Vector3 } from 'three';
    import { onDestroy, onMount } from 'svelte';
    import Map from './Map.svelte';
    import Cameras from './Cameras.svelte';
    import Characters from './Characters.svelte';
    import { recordingMode, replayMode, keyStateStore, isMouseDownStore, recordedMove, currentSubMove } from '../../stores/gameStores';
    import {handleKeyDown, handleKeyUp, handleMouseDown, handleMouseUp} from "$lib/handlers"
    import type { TurnData } from '../../stores/gameStores';
    import { truncateToDecimals } from '$lib/helper.';
    import { isMoveRecorded } from '../../stores/gameStores';

    let {renderer, scene, camera} = useThrelte();

    let frame_counter = 0;
    let move_speed = 1/3;
    let moveDirection = new Vector3();


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

            $currentSubMove.x += moveDirection.x;
            $currentSubMove.y += moveDirection.z;

            if (frame_counter % 3 == 0){
                let move = {
                    x: Math.abs(Math.round($currentSubMove.x * 100)),
                    y: Math.abs(Math.round($currentSubMove.y * 100)),
                    xdir: moveDirection.x >= 0,
                    ydir: moveDirection.z >= 0,
                };
                $recordedMove.sub_moves.push(move);
                currentSubMove.set({x:0, y:0});
            }
            frame_counter+=1;
        }

        if(frame_counter == 300) {
            recordingMode.set(false);
            isMoveRecorded.set(true);
            console.log($isMoveRecorded);
            frame_counter = 0;
        }

        moveDirection.x =0;
        moveDirection.z =0;

    }

    const replayMove = (move: TurnData) => {
        let move_index = frame_counter / 3;
        let sub_move = move.sub_moves[move_index];

        if (frame_counter % 3 == 0) {
            let x_dif = sub_move.x;
            let y_dif = sub_move.y;
            if (!sub_move.xdir) x_dif *= -1;
            if (!sub_move.ydir) y_dif *= -1;
            moveDirection = new Vector3(sub_move.x, 0, sub_move.y);
            $camera.position.add(moveDirection);
        }

        frame_counter += 1;

    }

    useTask( (delta) => {

        if ($recordingMode) {
            recordMove();
        }
        if ($replayMode) {
            replayMove($recordedMove);
        }

    })

</script>

<T.Group>
    <Cameras />
    <Map />
    <Characters />
</T.Group>
