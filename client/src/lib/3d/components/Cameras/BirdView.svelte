<script lang="ts">
  import { T } from '@threlte/core'
  import { OrbitControls } from '@threlte/extras'
  import { useThrelte } from '@threlte/core'
  let { camera = $bindable() } = $props();
  import * as THREE from 'three'

  let {renderer} = useThrelte()
</script>

<T.PerspectiveCamera
  makeDefault
  position={[35, 11, 35]}
  on:create={({ ref }) => {
    camera = ref
    ref.lookAt(new THREE.Vector3(0, 0, 0))
  }}
>
  <OrbitControls />
</T.PerspectiveCamera>
