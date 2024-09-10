<script lang="ts">
  import { T, useFrame } from '@threlte/core'

  // This let's light load on mount
  useFrame(() => {})
</script>

<T.Group>
  <T.AmbientLight intensity={0.5} />
  <T.DirectionalLight position={[10, 10, 10]} intensity={1} castShadow />
</T.Group>
