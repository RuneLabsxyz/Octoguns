<script lang="ts">
    import { selectionMode, isYourTurn, simMode, activeCameras, camera_coords, submitCameras } from "src/stores";
    import { get } from 'svelte/store';
    import { derived } from 'svelte/store';
    import { onMount } from "svelte";

    let selectedCameraIds: number[] = [];
    let canConfirm = false;

    // Reactive variables for grid layout
    let gridColumns = 4;
    let gridRows = 2;

    // Filter cameras where isOwner is true
    const ownedCameras = derived(camera_coords, $camera_coords => {
        const cameraArray = Object.values($camera_coords);
        return cameraArray.filter(camera => camera.isOwner);
    });
    $: console.log("ownedCameras", $ownedCameras);

    let usedCameras: number[] = [];

    $: {
        usedCameras = [];
        $submitCameras.forEach((item) => {
            usedCameras = [...usedCameras, ...item.characters];
        });
        // Remove cameras in usedCameras from selectedCameraIds
        selectedCameraIds = selectedCameraIds.filter(id => !usedCameras.includes(id));
    }

    function toggleCamera(id: number) {
        if (!usedCameras.includes(id)) {
            if (selectedCameraIds.includes(id)) {
                selectedCameraIds = selectedCameraIds.filter(i => i !== id);
            } else {
                selectedCameraIds = [...selectedCameraIds, id];
            }
        }
    }
    $: console.log("selection mode set to true", $selectionMode);

    $: canConfirm = selectedCameraIds.length > 0;

    function startRound() {
        simMode.set(true);
        console.log("SIMULATION", $simMode);
        activeCameras.set(selectedCameraIds);
        const activeCamerasList = get(activeCameras);
        gridColumns = Math.ceil(Math.sqrt(activeCamerasList.length));
        gridRows = Math.ceil(activeCamerasList.length / gridColumns);
        console.log('starting round with active camera IDs:', selectedCameraIds);
        // Pointer lock the cursor
        const canvas = document.querySelector('canvas');
        if (canvas) {
            canvas.requestPointerLock = canvas.requestPointerLock || canvas.mozRequestPointerLock;
            canvas.requestPointerLock();
        }
    }

    // Reactive to simMode changes
    $: if ($simMode) {
        const activeCamerasList = $activeCameras;
        gridColumns = Math.ceil(Math.sqrt(activeCamerasList.length));
        gridRows = Math.ceil(activeCamerasList.length / gridColumns);
    } else {
        gridColumns = 4;
        gridRows = 2;
    }

    $: console.log("usedCameras", usedCameras);
</script>

{#if $selectionMode}
    <div class="grid-overlay" style="grid-template-columns: repeat({gridColumns}, 1fr); grid-template-rows: repeat({gridRows}, 1fr);">
        {#each $ownedCameras as camera (camera.id)}
            <div class="cell" style="grid-column: span 1; grid-row: span 1;">
                {#if $isYourTurn && !$simMode}
                <input
                    type="checkbox"
                    checked={selectedCameraIds.includes(camera.id)}
                    on:change={() => toggleCamera(camera.id)}
                    disabled={usedCameras.includes(camera.id)}
                />
                <span class="camera-label">Camera {camera.id}</span>
                {/if}
            </div>
        {/each}
    </div>
    {#if canConfirm}
        <button class="confirm-button" on:click={startRound}>Confirm</button>
    {/if}
{/if}

<style>
    .grid-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: grid;
        border: 4px solid rgba(255, 0, 200, 0.5); /* Outer border */
    }
  
    .grid-overlay div {
        border-right: 4px solid rgba(255, 0, 255, 0.5); /* Vertical lines */
        border-bottom: 4px solid rgba(255, 0, 255, 0.5); /* Horizontal lines */
    }

    .grid-overlay .cell {
        position: relative;
    }
  
    .grid-overlay input[type="checkbox"] {
        position: absolute;
        bottom: 5px;
        right: 5px;
        width: 20px;
        height: 20px;
    }

    .confirm-button {
        position: absolute;
        top: 10px;
        left: 10px;
        padding: 5px 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 3px;
        cursor: pointer;
    }

    .camera-label {
        position: absolute;
        top: 5px;
        left: 5px;
        color: white;
        font-size: 12px;
        background-color: rgba(0, 0, 0, 0.5);
        padding: 2px 5px;
        border-radius: 3px;
    }
</style>
