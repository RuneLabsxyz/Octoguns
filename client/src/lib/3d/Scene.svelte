<script lang="ts">
  import { T, useThrelte } from '@threlte/core'
  import { onDestroy, onMount } from 'svelte'
  import Map from './components/Map.svelte'
  import Characters from './components/Characters.svelte'

  import BirdView from './components/Cameras/BirdView.svelte'
  import SplitScreen from './components/Cameras/SplitScreen.svelte'
  import {
    renderCameras,
    resetCamera,
  } from './components/Cameras/SplitScreen/CameraUtils'
  import { birdView } from '$stores/cameraStores'
  import { PerspectiveCamera } from 'three'
  import Bullets from './components/Bullets.svelte'

  import { writable } from 'svelte/store'

  import getGame from '$lib/api/svelte/context'
  import { rendererStore } from '$src/stores/gameStores'
  import { get } from 'svelte/store'

  import { useTask } from '@threlte/core'

  let { renderer, scene, camera } = useThrelte()
  const { controls, currentPlayerCharacterIds, frameCounter, move, currentCharacters } = getGame()

  let cameras: PerspectiveCamera[] = $state([])
  let numCameras = $state(1)
  let birdViewCamera: any = $state()


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
            camera.set(birdViewCamera)            
          }
        }
      } else {
        if (cameras.length > 0 && cameras.every((cam) => cam && cam.isCamera)) {
          let split_camera = renderCameras(cameras, renderer, scene)
          renderer.setScissorTest(false)
          camera.set(split_camera!)
        }
      }

      move.update(cameras)

    } catch (error) {
      console.error('Error in animation loop:', error)
      if (error instanceof TypeError && error.message.includes('byteLength')) {
        console.warn('Possible issue with buffer or geometry.')
      }
    }
  }

  useTask(() => {  
    animationLoop();
  })

  onMount(() => {
    addEventListeners()
    rendererStore.set(renderer)


    renderer.shadowMap.enabled = false

    return () => {
      removeEventListeners()
    }
  })

  onDestroy(() => {
    removeEventListeners()
  })
</script>

<T.Group>
  {#if $birdView}
    <BirdView bind:camera={birdViewCamera} />
  {:else}
    <SplitScreen bind:cameras={cameras} {numCameras} />
  {/if}
  <Map />
  <Characters />
  <Bullets />
</T.Group>
