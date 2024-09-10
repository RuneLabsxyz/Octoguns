<script lang="ts">
  import { T } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
</script>

<T.PerspectiveCamera makeDefault position={[15, 30, 20]}>
  <OrbitControls />
</T.PerspectiveCamera>
