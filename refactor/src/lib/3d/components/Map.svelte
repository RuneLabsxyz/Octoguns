<script lang="ts">
  import { T } from '@threlte/core'
  import Ground from './map/Ground.svelte'
  import Light from './map/Light.svelte'
  import Walls from './map/Walls.svelte'
</script>

<T.Group>
  <Ground />
  <Light />
  <Walls />
</T.Group>
