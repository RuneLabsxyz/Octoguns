<script lang="ts">
  import { T } from '@threlte/core'
  import Ground from './map/Ground.svelte'
  import Light from './map/Light.svelte'
  import Walls from './map/Walls.svelte'
  import GroundBox from './map/GroundBox.svelte'
  import SkyBox from './map/SkyBox.svelte'
  import Blocks from './map/Blocks.svelte'
  import { mapObjects } from '$stores/gameStores'
  import Splat from './map/Splat.svelte'
</script>

<T.Group>
  <Ground />
  <GroundBox />
  <Light />
  <Walls />
  <Blocks />
  <SkyBox />
  <Splat />
</T.Group>
