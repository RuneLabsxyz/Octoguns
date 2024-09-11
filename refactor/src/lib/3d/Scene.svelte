<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import { Vector3 } from 'three'
  import { onDestroy, onMount } from 'svelte'
  import Map from './components/Map.svelte'
  import Cameras from './components/Cameras.svelte'
  import Characters from './components/Characters.svelte'
  import {
    recordingMode,
    replayMode,
    keyStateStore,
    isMouseDownStore,
    recordedMove,
    currentSubMove,
    frameCounter,
  } from '$stores/gameStores'
  import {
    handleKeyDown,
    handleKeyUp,
    handleMouseDown,
    handleMouseUp,
  } from '$lib/handlers'
  import type { TurnData } from '$stores/gameStores'
  import { truncateToDecimals } from '$lib/helper.'
  import {
    isMoveRecorded,
    playerCharacterCoords,
    characterIds,
  } from '$stores/gameStores'
  import BirdView from './components/Cameras/BirdView.svelte'
  import SplitScreen from './components/Cameras/SplitScreen.svelte'
  import {
    renderCameras,
    resetCamera,
  } from './components/Cameras/SplitScreen/CameraUtils'
  import { birdView } from '$stores/cameraStores'

  let { renderer, scene, camera } = useThrelte()

  let cameras: any = []
  let numCameras = 1
  let birdViewCamera: any

  let move_speed = 1 / 3
  let moveDirection = new Vector3()
  export let characterId: number

  onMount(() => {
    window.addEventListener('keydown', handleKeyDown)
    window.addEventListener('keyup', handleKeyUp)
    window.addEventListener('mousedown', handleMouseDown)
    window.addEventListener('mouseup', handleMouseUp)

    const animationLoop = () => {
      if ($birdView) {
        if (birdViewCamera) {
          resetCamera(birdViewCamera, renderer)
          renderer.render(scene, birdViewCamera)
        }
      } else {
        renderCameras(cameras, numCameras, renderer, scene)
      }

      // Add the logic from useTask here
      if ($recordingMode) {
        recordMove()
      }
      if ($replayMode) {
        replayMove($recordedMove)
      }

      requestAnimationFrame(animationLoop)
    }

    animationLoop()

    return () => {
      cancelAnimationFrame(animationLoop)
    }
  })

  onDestroy(() => {
    window.removeEventListener('keydown', handleKeyDown)
    window.removeEventListener('keyup', handleKeyUp)
    window.removeEventListener('mousedown', handleMouseDown)
    window.removeEventListener('mouseup', handleMouseUp)
    renderer.setAnimationLoop(null)
  })

  const recordMove = () => {
    if ($keyStateStore.forward) moveDirection.z -= 1
    if ($keyStateStore.backward) moveDirection.z += 1
    if ($keyStateStore.left) moveDirection.x -= 1
    if ($keyStateStore.right) moveDirection.x += 1

    // Check if there's any movement or if the mouse is down (indicating a potential shooting action)
    if (moveDirection.length() > 0 || $isMouseDownStore) {
      moveDirection.normalize().multiplyScalar(move_speed)
      moveDirection.applyQuaternion($camera.quaternion)
      moveDirection.x = truncateToDecimals(moveDirection.x, 2)
      moveDirection.z = truncateToDecimals(moveDirection.z, 2)
      moveDirection.y = 0

      $playerCharacterCoords[characterId].x += moveDirection.x
      $playerCharacterCoords[characterId].y += moveDirection.z

      $currentSubMove.x += moveDirection.x
      $currentSubMove.y += moveDirection.z

      if ($frameCounter % 3 == 0) {
        let move = {
          x: Math.abs(Math.round($currentSubMove.x * 100)),
          y: Math.abs(Math.round($currentSubMove.y * 100)),
          xdir: $currentSubMove.x >= 0,
          ydir: $currentSubMove.y >= 0,
        }
        $recordedMove.sub_moves.push(move)
        currentSubMove.set({ x: 0, y: 0 })
      }
      $frameCounter += 1
    }

    if ($frameCounter == 300) {
      recordingMode.set(false)
      isMoveRecorded.set(true)
      console.log($isMoveRecorded)
    }

    moveDirection.x = 0
    moveDirection.z = 0
  }

  const replayMove = (move: TurnData) => {
    let move_index = $frameCounter / 3
    let sub_move = move.sub_moves[move_index]

    if ($frameCounter == 300) {
      replayMode.set(false)
    }
    if ($frameCounter % 3 == 0 && $frameCounter < 300) {
      let x_dif = sub_move.x
      let y_dif = sub_move.y
      if (!sub_move.xdir) x_dif *= -1
      if (!sub_move.ydir) y_dif *= -1
      $playerCharacterCoords[characterId].x += x_dif / 100
      $playerCharacterCoords[characterId].y += y_dif / 100
    }

    $frameCounter += 1
  }
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
