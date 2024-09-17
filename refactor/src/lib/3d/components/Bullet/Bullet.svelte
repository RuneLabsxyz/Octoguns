<script lang="ts">
  import { T } from '@threlte/core'
  import type { BulletCoords } from '$stores/coordsStores'

  export let bullet: BulletCoords
  const x = bullet.coords.x
  const y = bullet.coords.y
  let color = bullet.shot_by === 2 ? 'red' : 'blue'
</script>

<T.Mesh position={[x, 1, y]} scale={0.3}>
  <T.SphereGeometry />
  <T.MeshStandardMaterial {color} />
</T.Mesh>
