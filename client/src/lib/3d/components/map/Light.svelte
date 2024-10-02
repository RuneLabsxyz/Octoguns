<script lang="ts">
  import { T, useFrame } from '@threlte/core'
  import { PointLight } from 'three'

  // This let's light load on mount
  useFrame(() => {})
</script>

<T.Group>
  <T.AmbientLight intensity={0.5} />
  <T.DirectionalLight position={[10, 10, 10]} intensity={3} />
</T.Group>
