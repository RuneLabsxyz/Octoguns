<script lang="ts">
  import { selectedMap } from '$stores/clientStores'

  export let map: {
    map_id: number
    map_objects: { value: number }[]
  }

  let coordsArray: { x: number; y: number }[] = []

  $: if (map) {
    coordsArray = map.map_objects.map((index) => {
      let i = index.value
      let x = (i % 25) * 4 + 2
      let y = Math.floor(i / 25) * 4 + 2
      return { x, y }
    })
  }

  function selectMap() {
    selectedMap.set(map.map_id)
  }
</script>

<button
  class="minimap"
  class:selected={$selectedMap === map.map_id}
  on:click={selectMap}
>
  {#each coordsArray as coord}
    <div
      class="block"
      style="grid-column: {Math.floor(coord.x / 4) + 1}; grid-row: {Math.floor(
        coord.y / 4
      ) + 1}"
    ></div>
  {/each}
</button>

<style>
  .minimap {
    display: grid;
    grid-template-columns: repeat(25, 10px);
    grid-template-rows: repeat(25, 10px);
    gap: 1px;
    background-color: #333;
    position: relative;
    cursor: pointer;
    border: none;
    padding: 0;
    background: none;
    box-sizing: border-box;
    margin: 20px auto;
  }

  .minimap.selected {
    border: 2px solid red;
  }

  .block {
    width: 10px;
    height: 10px;
    background-color: blue;
  }
</style>
