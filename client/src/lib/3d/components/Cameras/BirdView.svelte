<script lang="ts">
  import { T } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import { useThrelte } from '@threlte/core'
  let { camera = $bindable() } = $props();

  let {renderer} = useThrelte()
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
