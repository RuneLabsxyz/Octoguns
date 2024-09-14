<script lang="ts">
  import type { BulletType } from '$stores/gameStores'
  import { T } from '@threlte/core'

  let color = 'red'

  export let bullet: BulletType
  const x = bullet.x
  const y = bullet.y
</script>

<T.Mesh position={[x, 1, y]} scale={0.1}>
  <T.SphereGeometry />
  <T.MeshStandardMaterial {color} />
</T.Mesh>
