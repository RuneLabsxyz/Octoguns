<script lang="ts">
  import { T } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import { useThrelte } from '@threlte/core'
  export let camera

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
