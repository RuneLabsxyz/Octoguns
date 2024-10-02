<script lang="ts">
  import { T } from '@threlte/core'
  import { BoxGeometry, Mesh, MeshStandardMaterial, Vector3 } from 'three'
  export let position: [number, number, number] = [0, 3, 0]
  const [x, y, z] = position
  let material = new MeshStandardMaterial({ color: 'blue' })
</script>

<T.Group position={[x, y, z]}>
  <T.Mesh>
    <T.BoxGeometry args={[0.1, 0.4, 0.1]} />
    <T is={material} />
  </T.Mesh>
  <T.Mesh position={[0, 0.2, 0.2]}>
    <T.BoxGeometry args={[0.1, 0.1, 0.7]} />
    <T is={material} />
  </T.Mesh>
</T.Group>
