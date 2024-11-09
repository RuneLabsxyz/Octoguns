<script lang="ts">
  import { run } from 'svelte/legacy'

  import { T, useThrelte } from '@threlte/core'
  import { onDestroy, onMount } from 'svelte'
  import Map from './components/Map.svelte'
  import Characters from './components/Characters.svelte'
  import {
    recordingMode,
    replayMode,
    recordedMove,
    rendererStore,
  } from '$stores/gameStores'

  import BirdView from './components/Cameras/BirdView.svelte'
  import SplitScreen from './components/Cameras/SplitScreen.svelte'
  import {
    renderCameras,
    resetCamera,
  } from './components/Cameras/SplitScreen/CameraUtils'
  import { birdView } from '$stores/cameraStores'
  import { recordMove, replayMove } from '$lib/3d/utils/moveUtils'
  import { Controls, PerspectiveCamera } from 'three'
  import Bullets from './components/Bullets.svelte'
  import { shoot, replayShot, simulate } from './utils/shootUtils'

  import { inPointerLock } from '$stores/cameraStores'
  import { writable } from 'svelte/store'

  import { RECORDING_FRAME_LIMIT } from '$lib/consts'
  import { Inspector } from 'three-inspect'
  import getGame from '$lib/api/svelte/context'

  let { renderer, scene } = useThrelte()
  const { controls, currentPlayerCharacterId, frameCounter, move } = getGame()

  let cameras: PerspectiveCamera[] = $state([])
  let numCameras = 1
  let birdViewCamera: any = $state()

  let characterId: number = $derived($currentPlayerCharacterId!)
  let hasShotInCurrentRecording = writable(false)

  let animationFrameId: number

  const addEventListeners = () => {
    window.addEventListener('keydown', controls.handleKeyDown)
    window.addEventListener('keyup', controls.handleKeyUp)
    window.addEventListener('mousedown', controls.handleMouseDown)
    window.addEventListener('mouseup', controls.handleMouseUp)
  }

  const removeEventListeners = () => {
    window.removeEventListener('keydown', controls.handleKeyDown)
    window.removeEventListener('keyup', controls.handleKeyUp)
    window.removeEventListener('mousedown', controls.handleMouseDown)
    window.removeEventListener('mouseup', controls.handleMouseUp)
  }

  // TODO(Red): Start to refactor this
  const animationLoop = () => {
    try {
      if ($birdView) {
        if (birdViewCamera && birdViewCamera.isCamera) {
          resetCamera(birdViewCamera, renderer)
          if (scene && scene.isScene) {
            renderer.render(scene, birdViewCamera)
          }
        }
      } else {
        if (cameras.length > 0 && cameras.every((cam) => cam && cam.isCamera)) {
          renderCameras(cameras, numCameras, renderer, scene)
        }
      }

      // TODO(Red): This should be in the move controller
      if ($recordingMode) {
        move.update(cameras[0])
        // TODO(Red): This needs to move on the update method of the store
        //if (
        //  $isMouseDownStore &&
        //  $inPointerLock &&
        //  !$hasShotInCurrentRecording
        //) {
        //  shoot(cameras[0]) // currently only works with one camera
        //  hasShotInCurrentRecording.set(true)
        //}
      }

      // TODO(Red): How to neatly handle the replay mode?
      if ($replayMode) {
        if ($frameCounter > RECORDING_FRAME_LIMIT) {
          console.log('eyyy, tf')
          replayMode.set(false)
        }
        replayMove($recordedMove, characterId)
        replayShot($recordedMove, cameras[0])
      }

      animationFrameId = requestAnimationFrame(animationLoop)
    } catch (error) {
      console.error('Error in animation loop:', error)
      if (error instanceof TypeError && error.message.includes('byteLength')) {
        console.warn('Possible issue with buffer or geometry.')
      }
    }
  }

  // Red: I don't know what this does, but at this point I'm too afraid to touch it
  $effect(() => {
    if ($frameCounter) {
      simulate()
    }
  })

  $effect(() => {
    if ($recordingMode) {
      hasShotInCurrentRecording.set(false)
    }
  })

  onMount(() => {
    addEventListeners()
    animationLoop()
    rendererStore.set(renderer)

    renderer.shadowMap.enabled = false

    return () => {
      removeEventListeners()
      cancelAnimationFrame(animationFrameId)
    }
  })

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
  <Inspector />
</T.Group>
