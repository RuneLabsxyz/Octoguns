<script lang="ts">
  import { T } from '@threlte/core'
  import Ground from './map/Ground.svelte'
  import Light from './map/Light.svelte'
  import Walls from './map/Walls.svelte'
  import GroundBox from './map/GroundBox.svelte'
  import SkyBox from './map/SkyBox.svelte'
</script>

<T.Group>
  <Ground />
  <GroundBox />
  <Light />
  <Walls />
  <SkyBox />
</T.Group>
