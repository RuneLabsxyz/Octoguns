<script lang="ts">
  import { T } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import PointerLock from './SplitScreen/PointerLock.svelte'

  export let cameras: PerspectiveCamera[] = []
  export let numCameras: number = 4
</script>

<PointerLock {cameras} />
{#each Array(numCameras) as _, index}
  <T.PerspectiveCamera
    position={[10 * (index % 2 === 0 ? 1 : -1), 10, 10]}
    on:create={({ ref }) => {
      cameras[index] = ref
      ref.lookAt(0, 1, 0)
    }}
  />
{/each}
