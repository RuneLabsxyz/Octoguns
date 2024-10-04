<script lang="ts">
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';
  import { dojoStore } from '$stores/dojoStore';
  import { account } from '$stores/account'
  import type { Account } from 'starknet';


  const gridSize = 25;
  const totalCells = gridSize * gridSize;
  const grid = writable<number[]>([]);

  let { client } = $dojoStore;


  onMount(() => {
    // Initialize the grid with no active cells
    grid.set([]);
  });

  function toggleCell(row: number, col: number) {
    const index = row * gridSize + col;
    grid.update(currentGrid => {
      if (currentGrid.includes(index)) {
        // Remove the index if it's already active
        return currentGrid.filter(i => i !== index);
      } else {
        // Add the index to activate the cell
        return [...currentGrid, index];
      }
    });
  }

  function resetGrid() {
    grid.set([]);
  }

  function submit() {
    client.mapmaker.create({account: $account, objects: {objects: $grid}});
  }

  function isActive(index: number, activeIndices: number[]): boolean {
    return activeIndices.includes(index);
  }
</script>

<style>
  .grid {
    display: grid;
    grid-template-columns: repeat(25, 20px);
    grid-template-rows: repeat(25, 20px);
    gap: 2px;
    margin: 20px auto;
    width: max-content;
  }

  .cell {
    width: 20px;
    height: 20px;
    background-color: #f0f0f0;
    border: 1px solid #ccc;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .cell.active {
    background-color: #4caf50;
  }

  .controls {
    text-align: center;
    margin-top: 10px;
  }
</style>

<div class="controls">
  <button class = "ml-4 px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-700 transition" on:click={resetGrid}>Reset Grid</button>
  <button class = "mr-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition" on:click={submit}>Submit</button>
</div>

<div class="grid">
  {#each Array(totalCells) as _, index}
    <div
      class="cell {isActive(index, $grid) ? 'active' : ''}"
      on:click={() => toggleCell(Math.floor(index / gridSize), index % gridSize)}
    ></div>
  {/each}
</div>
