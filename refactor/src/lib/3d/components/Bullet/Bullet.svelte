<script lang="ts">
  import { T } from '@threlte/core'
  import type { BulletCoords } from '$stores/coordsStores'

  export let bullet: BulletCoords
  export let initialPosition: BulletCoords | undefined

  $: x = bullet.coords.x
  $: y = bullet.coords.y
  $: color = bullet.shot_by === 2 ? 'red' : 'blue'

  $: initialX = initialPosition?.coords.x
  $: initialY = initialPosition?.coords.y
</script>

<T.Group>
  <!-- Current bullet position (moving) -->
  <T.Mesh position={[x, 1, y]} scale={0.3}>
    <T.SphereGeometry />
    <T.MeshStandardMaterial {color} />
  </T.Mesh>

  <!-- Initial bullet position (static) -->
  {#if initialPosition}
    <T.Mesh position={[initialX, 1, initialY]} scale={0.2}>
      <T.SphereGeometry />
      <T.MeshStandardMaterial color="green" />
    </T.Mesh>
  {/if}
</T.Group>
