<script lang="ts">
  import { T } from '@threlte/core'
  import { Edges } from '@threlte/extras'
</script>

<T.Mesh receiveShadow position={[0, 0, 0]} rotation={[-Math.PI / 2, 0, 0]}>
  <T.PlaneGeometry args={[100, 100]} />
  <T.MeshPhysicalMaterial color="#ffffff" />
</T.Mesh>
