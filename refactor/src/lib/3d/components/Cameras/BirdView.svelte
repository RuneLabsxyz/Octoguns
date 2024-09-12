<script lang="ts">
  import { T } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'

  export let camera
</script>

<T.PerspectiveCamera
  makeDefault
  position={[15, 30, 20]}
  on:create={({ ref }) => {
    camera = ref
  }}
>
  <OrbitControls />
</T.PerspectiveCamera>
