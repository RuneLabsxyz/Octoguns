<script lang="ts">
  import { run } from 'svelte/legacy';

  import { selectedMap } from '$stores/clientStores';

  interface Props {
    map: {
    map_id: number;
    grid1: number;
    grid2: number;
    grid3: number;
  };
  }

  let { map }: Props = $props();

  let coordsArray: { x: number; y: number }[] = $state([]);

  /**
   * Extracts active indices from three u256 bitmaps.
   * @param decimalGrids An array of three u256 bitmaps as BigInts.
   * @returns An array of active indices.
   */
  function extractActiveIndices(decimalGrids: bigint[]): number[] {
    const activeIndices: number[] = [];

    // Process grid1 (indices 0 to 207)
    for (let i = 0; i < 208; i++) {
      if ((decimalGrids[0] & (1n << BigInt(i))) !== 0n) {
        activeIndices.push(i);
      }
    }

    // Process grid2 (indices 208 to 415)
    for (let i = 0; i < 208; i++) {
      if ((decimalGrids[1] & (1n << BigInt(i))) !== 0n) {
        activeIndices.push(i + 208);
      }
    }

    // Process grid3 (indices 416 to 624)
    for (let i = 0; i < 209; i++) {
      if ((decimalGrids[2] & (1n << BigInt(i))) !== 0n) {
        activeIndices.push(i + 416);
      }
    }

    return activeIndices;
  }

  run(() => {
    if (map && map.grid1 !== undefined && map.grid2 !== undefined && map.grid3 !== undefined) {
      const grids = [map.grid1, map.grid2, map.grid3];
      coordsArray = [];
      let decimalGrids: bigint[] = [];

      grids.forEach((grid) => {
        // Convert hex to decimal
        let decimal = BigInt(`0x${grid.toString(16)}`).toString(10);
        decimalGrids.push(BigInt(decimal));
      });
      let activeIndices = extractActiveIndices(decimalGrids);
      coordsArray = activeIndices.map((index) => {
        const x = index % 25;
        const y = Math.floor(index / 25);
        return { x, y };
      });
    }
  });

  function selectMap() {
    selectedMap.set(map.map_id);
  }
</script>

<button class="minimap" onclick={selectMap} title={`Select Map ID: ${map.map_id}`}>
  {#each coordsArray as coord}
    <div
      class="block"
      style="grid-column: {coord.x + 1}; grid-row: {coord.y + 1}"
    ></div>
  {/each}
</button>

<style>
  .minimap {
    display: grid;
    grid-template-columns: repeat(25, 10px);
    grid-template-rows: repeat(25, 10px);
    gap: 1px;
    position: relative;
    cursor: pointer;
    border: 1px solid #ccc; 
    padding: 0;
    background-color: #fff;
    box-sizing: border-box;
    width: max-content;
    height: max-content;
  }

  .block {
    width: 10px;
    height: 10px;
    background-color: blue;
  }

  .minimap:hover .block {
    background-color: darkblue; 
  }
</style>
