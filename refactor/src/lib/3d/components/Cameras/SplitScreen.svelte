<script lang="ts">
  import { invalidate } from '$app/navigation'
  import { Canvas, T, useThrelte, useTask } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import SplitScreen from './SplitScreen/PointerLock.svelte'
  import { renderCameras } from './SplitScreen/CameraUtils'

  let cameras: PerspectiveCamera[] = []
  let numCameras: number = 8

  const { renderer, scene } = useThrelte()

  useTask(() => {
    renderer.setAnimationLoop(() =>
      renderCameras(cameras, numCameras, renderer, scene)
    )
  })
</script>

<SplitScreen {cameras} />
{#each Array(numCameras) as _, index}
  <T.PerspectiveCamera
    position={[10 * (index % 2 === 0 ? 1 : -1), 10, 10]}
    on:create={({ ref }) => {
      cameras[index] = ref
      ref.lookAt(0, 1, 0)
    }}
  />
{/each}
