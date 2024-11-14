<script lang="ts">
  import { T } from '@threlte/core'
  import { FakeGlowMaterial } from '@threlte/extras'
  import { Edges } from '@threlte/extras'
  import { GLTF } from '@threlte/extras'
</script>

<T.Mesh position={[1, 10, 40]}>
  <GLTF url={'/landscape.glb'} scale={4} />
</T.Mesh>
