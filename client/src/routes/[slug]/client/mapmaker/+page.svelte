<script lang="ts">
  import { onMount } from 'svelte'
  import { writable } from 'svelte/store'
  import TxToast from '$lib/ui/TxToast.svelte'
  import { goto } from '$app/navigation'
  import { env } from '$stores/network'
  import { createMap } from '$lib/api/actions'

  const gridSize = 25
  const totalCells = gridSize * gridSize
  const grid = writable<number[]>([])

  let toastMessage = $state('')
  let toastStatus = $state('loading')
  let showToast = $state(false)

  onMount(() => {
    grid.set([])
  })

  function toggleCell(row: number, col: number) {
    const index = row * gridSize + col
    grid.update((currentGrid) => {
      if (currentGrid.includes(index)) {
        // Remove the index if it's already active
        return currentGrid.filter((i) => i !== index)
      } else {
        // Add the index to activate the cell
        return [...currentGrid, index]
      }
    })
  }

  function resetGrid() {
    grid.set([])
  }

  /**
   * Converts active grid indices into three u256 bitmaps.
   * @param activeIndices Array of active cell indices.
   * @returns An object containing grid1, grid2, and grid3 as BigInts.
   */
  function computeGrids(activeIndices: number[]): {
    grid1: bigint
    grid2: bigint
    grid3: bigint
  } {
    let grid1 = BigInt(0)
    let grid2 = BigInt(0)
    let grid3 = BigInt(0)

    activeIndices.forEach((index) => {
      if (index < 208) {
        // Indices 0 to 207 go to grid1
        grid1 |= 1n << BigInt(index)
      } else if (index < 416) {
        // Indices 208 to 415 go to grid2
        grid2 |= 1n << BigInt(index - 208)
      } else if (index < 625) {
        // Indices 416 to 624 go to grid3
        grid3 |= 1n << BigInt(index - 416)
      } else {
        console.warn(`Index ${index} out of range for current grid setup.`)
      }
    })

    return { grid1, grid2, grid3 }
  }

  async function submit() {
    showToast = true
    toastMessage = 'Creating map...'
    toastStatus = 'loading'
    try {
      const { grid1, grid2, grid3 } = computeGrids($grid)

      createMap(grid1, grid2, grid3)

      toastMessage = 'Map created successfully!'
      toastStatus = 'success'
      setTimeout(() => {
        goto(`/${$env}/client/games/openGames`)
      }, 2000)
    } catch (error) {
      console.error('Error creating map:', error)
      toastMessage = 'Failed to create map.'
      toastStatus = 'error'
    }
  }

  function isActive(index: number, activeIndices: number[]): boolean {
    return activeIndices.includes(index)
  }
</script>

<div class="controls">
  <button
    class="ml-4 px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-700 transition"
    onclick={resetGrid}
  >
    Reset Grid
  </button>
  <button
    class="mr-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
    onclick={submit}
  >
    Submit
  </button>
</div>

<div class="grid">
  {#each Array(totalCells) as _, index}
    <button
      type="button"
      class="cell {isActive(index, $grid) ? 'active' : ''}"
      onclick={() => toggleCell(Math.floor(index / gridSize), index % gridSize)}
      onkeydown={(e) =>
        e.key === 'Enter' &&
        toggleCell(Math.floor(index / gridSize), index % gridSize)}
    ></button>
  {/each}
</div>

{#if showToast}
  <TxToast message={toastMessage} status={toastStatus} />
{/if}

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
