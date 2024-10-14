<script lang="ts">
  import { selectedMap } from '$stores/clientStores';

  export let map: {
    map_id: number;
    map_objects: { value: number }[];
  };

  let coordsArray: { x: number; y: number }[] = [];

  $: if (map && map.map_objects) {
    coordsArray = map.map_objects.map((obj) => {
      const i = obj.value;
      const x = (i % 25);
      const y = Math.floor(i / 25); 
      return { x, y };
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
