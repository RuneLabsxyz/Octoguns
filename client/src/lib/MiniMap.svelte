<script lang="ts">
  import { selectedMap } from '$stores/clientStores';

  export let map: {
    map_id: number;
    grid1: number;
    grid2: number;
    grid3: number;
  };

  let coordsArray: { x: number; y: number }[] = [];

  $: if (map && map.grid1 && map.grid2 && map.grid3) {
    console.log('map', map);
    const grids = [map.grid1, map.grid2, map.grid3];
    coordsArray = [];

    grids.forEach((grid, gridIndex) => {
      const binary = BigInt(grid).toString(2).padStart(128, '0'); // Contracts uses 128 bits per grid part
      
      for (let i = 0; i < binary.length; i++) {
        if (binary[i] === '1') {
          const x = i % 25; // Grid width is 25 
          const y = Math.floor(i / 25) + gridIndex * 16; 
          coordsArray.push({ x, y });
        }
      }
    });
  }

  function selectMap() {
    selectedMap.set(map.map_id);
  }
</script>

<button class="minimap" on:click={selectMap} title={`Select Map ID: ${map.map_id}`}>
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
