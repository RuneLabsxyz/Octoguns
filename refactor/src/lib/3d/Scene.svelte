<script lang="ts">
  import { T, useThrelte } from '@threlte/core'
  import { onDestroy, onMount } from 'svelte'
  import Map from './components/Map.svelte'
  import Characters from './components/Characters.svelte'
  import { recordingMode, replayMode, recordedMove } from '$stores/gameStores'
  import {
    handleKeyDown,
    handleKeyUp,
    handleMouseDown,
    handleMouseUp,
  } from '$lib/handlers'
  import BirdView from './components/Cameras/BirdView.svelte'
  import SplitScreen from './components/Cameras/SplitScreen.svelte'
  import {
    renderCameras,
    resetCamera,
  } from './components/Cameras/SplitScreen/CameraUtils'
  import { birdView } from '$stores/cameraStores'
  import { recordMove, replayMove } from '$lib/3d/utils/moveUtils'
  import { PerspectiveCamera } from 'three'

  let { renderer, scene } = useThrelte()

  let cameras: PerspectiveCamera[] = []
  let numCameras = 1
  let birdViewCamera: any

  export let characterId: number

  onMount(() => {
    window.addEventListener('keydown', handleKeyDown)
    window.addEventListener('keyup', handleKeyUp)
    window.addEventListener('mousedown', handleMouseDown)
    window.addEventListener('mouseup', handleMouseUp)

    let animationFrameId: number

    const animationLoop = () => {
      if ($birdView) {
        if (birdViewCamera) {
          resetCamera(birdViewCamera, renderer)
          renderer.render(scene, birdViewCamera)
        }
      } else {
        renderCameras(cameras, numCameras, renderer, scene)
      }

      if ($recordingMode) {
        recordMove(cameras[0], characterId)
      }
      if ($replayMode) {
        replayMove($recordedMove, characterId)
      }

      animationFrameId = requestAnimationFrame(animationLoop)
    }

    animationLoop()

    return () => {
      cancelAnimationFrame(animationFrameId)
      window.removeEventListener('keydown', handleKeyDown)
      window.removeEventListener('keyup', handleKeyUp)
      window.removeEventListener('mousedown', handleMouseDown)
      window.removeEventListener('mouseup', handleMouseUp)
    }
  })

  onDestroy(() => {
    window.removeEventListener('keydown', handleKeyDown)
    window.removeEventListener('keyup', handleKeyUp)
    window.removeEventListener('mousedown', handleMouseDown)
    window.removeEventListener('mouseup', handleMouseUp)
    renderer.setAnimationLoop(null)
  })
</script>

<T.Group>
  {#if $birdView}
    <BirdView bind:camera={birdViewCamera} />
  {:else}
    <SplitScreen bind:cameras {numCameras} />
  {/if}
  <Map />
  <Characters />
</T.Group>
