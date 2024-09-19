<script lang="ts">
  import { T } from '@threlte/core'
  import Ground from './map/Ground.svelte'
  import Light from './map/Light.svelte'
  import Walls from './map/Walls.svelte'
  import GroundBox from './map/GroundBox.svelte'
  import SkyBox from './map/SkyBox.svelte'
  import { mapObjects } from '$stores/gameStores'

  let coordsArray: {x: number, y: number}[] = []

  $: if ($mapObjects) {
    $mapObjects.objects.forEach((index) => {
      //@ts-ignore
      let i = index.value
      let x = ( i % 25 * 4) + 2;
      let y = (Math.floor(i / 25) * 4) + 2;
      coordsArray.push({x: x, y: y})
    })
    console.log(coordsArray)
  } 
</script>

<T.Group>
  <Ground />
  <GroundBox />
  <Light />
  <Walls />
  {#each coordsArray as coord}
    <T.Mesh position={[coord.x - 50, 0, coord.y - 50]}>
      <T.BoxGeometry args={[4, 1, 4]} />
      <T.MeshStandardMaterial color="blue" />
    </T.Mesh>
  {/each}
  <SkyBox />
</T.Group>
