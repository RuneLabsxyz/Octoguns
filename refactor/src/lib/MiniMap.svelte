<script lang="ts">
  import { selectedMap } from '$stores/clientStores'
  import { cn } from './css/cn'
  import Button from './ui/Button.svelte'

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

<div class="minimap">
  {#each coordsArray as coord}
    <div
      class="block"
      style="grid-column: {Math.floor(coord.x / 4) + 1}; grid-row: {Math.floor(
        coord.y / 4
      ) + 1}"
    ></div>
  {/each}
</div>

<style>
  .minimap {
    display: grid;
    grid-template-columns: repeat(25, 10px);
    grid-template-rows: repeat(25, 10px);
    gap: 1px;
    position: relative;
    cursor: pointer;
    border: none;
    padding: 0;
    background: none;
    box-sizing: border-box;
    width: max-content;
    height: max-content;
  }
  .block {
    width: 10px;
    height: 10px;
    background-color: blue;
  }
</style>
