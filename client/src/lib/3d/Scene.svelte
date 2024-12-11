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

  let { renderer, scene } = useThrelte()
  const { controls, currentPlayerCharacterIds, frameCounter, move, currentCharacters } = getGame()

  let cameras: PerspectiveCamera[] = $state([])
  let numCameras = $state(1)
  let birdViewCamera: any = $state()
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
          renderCameras(cameras, renderer, scene)
        }
      }

      move.update(cameras)

      animationFrameId = requestAnimationFrame(animationLoop)
    } catch (error) {
      console.error('Error in animation loop:', error)
      if (error instanceof TypeError && error.message.includes('byteLength')) {
        console.warn('Possible issue with buffer or geometry.')
      }
    }
  }

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
    <SplitScreen bind:cameras={cameras} {numCameras} />
  {/if}
  <Map />
  <Characters />
  <Bullets />
</T.Group>
