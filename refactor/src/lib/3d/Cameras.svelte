<script lang="ts">
    import { T } from '@threlte/core';
    import { OrbitControls } from '@threlte/extras'
    // TEMPORARY
    let birdView: boolean = false;
</script>

<T.PerspectiveCamera
    makeDefault
    position={[10, 10, 10]}
  >
  <OrbitControls />
</T.PerspectiveCamera>