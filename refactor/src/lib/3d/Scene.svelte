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
  import Bullets from './components/Bullet/Bullets.svelte'
  import { shoot, replayShot } from './components/Bullet/shoot'
  import { isMouseDownStore, playerCharacterId } from '$stores/gameStores'
  import { inPointerLock } from '$stores/cameraStores'
  import { writable } from 'svelte/store'

  let { renderer, scene } = useThrelte()
  let cameras: PerspectiveCamera[] = []
  let numCameras = 1
  let birdViewCamera: any

  let characterId: number = $playerCharacterId

  let hasShotInCurrentRecording = writable(false)

  let animationFrameId: number

  const addEventListeners = () => {
    window.addEventListener('keydown', handleKeyDown)
    window.addEventListener('keyup', handleKeyUp)
    window.addEventListener('mousedown', handleMouseDown)
    window.addEventListener('mouseup', handleMouseUp)
  }

  const removeEventListeners = () => {
    window.removeEventListener('keydown', handleKeyDown)
    window.removeEventListener('keyup', handleKeyUp)
    window.removeEventListener('mousedown', handleMouseDown)
    window.removeEventListener('mouseup', handleMouseUp)
  }

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
      if ($isMouseDownStore && $inPointerLock && !$hasShotInCurrentRecording) {
        shoot(cameras[0]) // currently only works with one camera
        hasShotInCurrentRecording.set(true)
      }
    }
    if ($replayMode) {
      replayMove($recordedMove, characterId)
      replayShot($recordedMove)
    }

    animationFrameId = requestAnimationFrame(animationLoop)
  }

  onMount(() => {
    addEventListeners()
    animationLoop()

    return () => {
      removeEventListeners()
      cancelAnimationFrame(animationFrameId)
    }
  })

  $: if ($recordingMode) {
    hasShotInCurrentRecording.set(false)
  }

  onDestroy(() => {
    removeEventListeners()
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
  <Bullets />
</T.Group>
