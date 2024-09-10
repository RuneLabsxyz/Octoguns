<script lang="ts">
  import { invalidate } from '$app/navigation'
  import { Canvas, T, useThrelte, useTask } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import SplitScreen from './SplitScreen/PointerLock.svelte'

  let cameras: PerspectiveCamera[] = []
  let numCameras: number = 1

  const { renderer, scene } = useThrelte()

  useTask(() => {
    function renderCameras() {
      const { width, height } = renderer.domElement

      if (cameras.length === numCameras) {
        const rows = Math.ceil(Math.sqrt(numCameras))
        const cols = Math.ceil(numCameras / rows)
        const cameraWidth = width / cols
        const cameraHeight = height / rows

        cameras.forEach((camera, index) => {
          const row = Math.floor(index / cols)
          const col = index % cols

          camera.aspect = cameraWidth / cameraHeight
          camera.updateProjectionMatrix()

          renderer.setScissorTest(true)
          renderer.setViewport(
            col * cameraWidth,
            row * cameraHeight,
            cameraWidth,
            cameraHeight
          )
          renderer.setScissor(
            col * cameraWidth,
            row * cameraHeight,
            cameraWidth,
            cameraHeight
          )
          renderer.render(scene, camera)
        })

        renderer.setScissorTest(false)
      }
    }

    renderer.setAnimationLoop(renderCameras)
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
