<script lang="ts">
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';
  import { dojoStore } from '$stores/dojoStore';
  import { account } from '$stores/account'
  import TxToast from '$lib/ui/TxToast.svelte';
  import { goto } from '$app/navigation';

  const gridSize = 25;
  const totalCells = gridSize * gridSize;
  const grid = writable<number[]>([]);

  let { client } = $dojoStore;

  let toastMessage = '';
  let toastStatus = 'loading';
  let showToast = false;

  onMount(() => {
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

  async function submit() {
    showToast = true;
    toastMessage = 'Creating map...';
    toastStatus = 'loading';
    try {
      await client.mapmaker.create({account: $account, objects: {objects: $grid}});
      toastMessage = 'Map created successfully!';
      toastStatus = 'success';
      setTimeout(() => {
        goto('/client/games/openGames');
      }, 2000);
    } catch (error) {
      console.error('Error creating map:', error);
      toastMessage = 'Failed to create map.';
      toastStatus = 'error';
    }
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
  <button class="ml-4 px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-700 transition" on:click={resetGrid}>Reset Grid</button>
  <button class="mr-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition" on:click={submit}>Submit</button>
</div>

<div class="grid">
  {#each Array(totalCells) as _, index}
    <button
      type="button"
      class="cell {isActive(index, $grid) ? 'active' : ''}"
      on:click={() => toggleCell(Math.floor(index / gridSize), index % gridSize)}
      on:keydown={(e) => e.key === 'Enter' && toggleCell(Math.floor(index / gridSize), index % gridSize)}
    />
  {/each}
</div>

{#if showToast}
  <TxToast message={toastMessage} status={toastStatus} />
{/if}
