<script lang="ts">
    import { selectionMode } from "src/stores";
    let selectedCells: number[] = [];
    let canConfirm = false;

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
        console.log('starting round');
    }
</script>

{#if $selectionMode}
    <div class="grid-overlay">
        {#each Array(8) as _, index}
            <div class="cell">
                <input
                    type="checkbox"
                    checked={selectedCells.includes(index)}
                    on:change={() => toggleCell(index)}
                />
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
        grid-template-columns: repeat(4, 1fr);
        grid-template-rows: repeat(2, 1fr);
        border: 4px solid rgba(255, 0, 200, 0.5); /* Outer border */
    }
  
    .grid-overlay div {
        border-right: 4px solid rgba(255, 0, 255, 0.5); /* Vertical lines */
        border-bottom: 4px solid rgba(255, 0, 255, 0.5); /* Horizontal lines */
    }
  
    .grid-overlay div:nth-child(4n) {
        border-right: none; /* Remove the right border on the last column */
    }
  
    .grid-overlay div:nth-last-child(-n+4) {
        border-bottom: none; /* Remove the bottom border on the last row */
    }
  
    .grid-overlay .cell {
        position: relative;
        border-right: 4px solid rgba(255, 0, 255, 0.5);
        border-bottom: 4px solid rgba(255, 0, 255, 0.5);
    }
  
    .grid-overlay .cell:nth-child(4n) {
        border-right: none;
    }
  
    .grid-overlay .cell:nth-last-child(-n+4) {
        border-bottom: none;
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

