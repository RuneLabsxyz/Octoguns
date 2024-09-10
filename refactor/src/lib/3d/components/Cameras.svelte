<script lang="ts">
  import Splitscreen from './Cameras/SplitScreen.svelte'
  import BirdView from './Cameras/BirdView.svelte'
  import { birdView } from '$stores/cameraStores'
  import { onMount, onDestroy } from 'svelte'
  import { useThrelte } from '@threlte/core'
  import { renderCameras, resetCamera } from './Cameras/SplitScreen/CameraUtils'

  const { renderer, scene } = useThrelte()

  let cameras: any = []
  let numCameras = 4
  let birdViewCamera: any

  onMount(() => {
    const animationLoop = () => {
      if ($birdView) {
        if (birdViewCamera) {
          resetCamera(birdViewCamera, renderer)
          renderer.render(scene, birdViewCamera)
        }
      } else {
        renderCameras(cameras, numCameras, renderer, scene)
      }
    }

    renderer.setAnimationLoop(animationLoop)

    return () => {
      renderer.setAnimationLoop(null)
    }
  })
</script>

{#if $birdView}
  <BirdView bind:camera={birdViewCamera} />
{:else}
  <Splitscreen bind:cameras {numCameras} />
{/if}
