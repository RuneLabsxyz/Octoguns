<script lang="ts">
    import { selectionMode, isYourTurn, simMode, activeCameras } from "src/stores";
    import { get } from 'svelte/store';

    let selectedCells: number[] = [];
    let canConfirm = false;

    // Reactive variables for grid layout
    let gridColumns = 4;
    let gridRows = 2;

    function toggleCell(index: number) {
        if (selectedCells.includes(index)) {
            selectedCells = selectedCells.filter(i => i !== index);
        } else {
            selectedCells = [...selectedCells, index];
        }
    }

    $: if (selectedCells.length > 0) {
        canConfirm = true;
    } else {
        canConfirm = false;
    }

    function startRound() {
        simMode.set(true);
        activeCameras.set(selectedCells);
        const activeCamerasList = get(activeCameras);
        gridColumns = Math.ceil(Math.sqrt(activeCamerasList.length));
        gridRows = Math.ceil(activeCamerasList.length / gridColumns);
        console.log('starting round with active cameras:', activeCamerasList);
        // Pointer lock the cursor
        const canvas = document.querySelector('canvas');
        if (canvas) {
            canvas.requestPointerLock = canvas.requestPointerLock || canvas.mozRequestPointerLock;
            canvas.requestPointerLock();
        }
    }

    // Reactive to simMode changes
    $: if ($simMode) {
        const activeCamerasList = get(activeCameras);
        gridColumns = Math.ceil(Math.sqrt(activeCamerasList.length));
        gridRows = Math.ceil(activeCamerasList.length / gridColumns);
    } else {
        gridColumns = 4;
        gridRows = 2;
    }
</script>

{#if $selectionMode}
    <div class="grid-overlay" style="grid-template-columns: repeat({gridColumns}, 1fr); grid-template-rows: repeat({gridRows}, 1fr);">
        {#each Array(8) as _, index}
            <div class="cell" style="grid-column: span 1; grid-row: span 1;">
                {#if isYourTurn && !$simMode}
                <input
                    type="checkbox"
                    checked={selectedCells.includes(index)}
                    on:change={() => toggleCell(index)}
                />
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
</style>
