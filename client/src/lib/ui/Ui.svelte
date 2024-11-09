<script lang="ts">
  import { run } from 'svelte/legacy'

  import StartGame from './StartGame.svelte'
  import { birdView } from '$stores/cameraStores'
  import { isEnded, recordingMode, replayMode } from '$stores/gameStores'
  import {
    currentSubMove,
    recordedMove,
    isMoveRecorded,
    playerCharacterId,
    frameCounter,
    isTurnPlayer,
    rendererStore,
    gameState,
  } from '$stores/gameStores'
  import {
    setPlayerCharacterCoords,
    playerStartCoords,
    bulletStart,
    bulletRender,
  } from '$stores/coordsStores'
  import { resetBullets } from '$lib/3d/utils/shootUtils.js'
  import { inPointerLock } from '$stores/cameraStores'
  import { get } from 'svelte/store'
  import StepBar from './StepBar.svelte'
  import InGameOverlay from './ingame/InGameOverlay.svelte'
  import Banner from './ingame/Banner.svelte'
  import WaitingForTurn from './ingame/banner/WaitingForTurn.svelte'
  import Button from './Button.svelte'
  import { Eraser, Repeat, Send } from 'lucide-svelte'
  import GameFinished from './ingame/GameFinished.svelte'
  import getGame from '$lib/api/svelte/context'

  let { session } = getGame()

  run(() => {
    if (isMoveRecorded) {
      if (isRecorded == true && $isMoveRecorded == false && !hasReset) {
        // This is just sad, but I don't see a way to make it better
        justRecorded = true
        setTimeout(() => {
          justRecorded = false
        }, 5000)
      }
      hasReset = false
      isRecorded = $isMoveRecorded
    }
  })

  function setRecordingMode(e: Event) {
    recordingMode.set(!$recordingMode)
    birdView.set(false)
    replayMode.set(false)
    inPointerLock.set(true)
    get(rendererStore).domElement.requestPointerLock()
  }

  function setReplayMode(e: Event) {
    recordingMode.set(false)
    frameCounter.set(0)
    setPlayerCharacterCoords(
      $playerCharacterId,
      $playerStartCoords[$playerCharacterId]
    )
    replayMode.set(!$recordingMode)
    resetBullets()
  }

  function reset(e: Event) {
    currentSubMove.set({ x: 0, y: 0 })
    setPlayerCharacterCoords(
      $playerCharacterId,
      $playerStartCoords[$playerCharacterId]
    )
    frameCounter.set(0)
    recordedMove.set({ sub_moves: [], shots: [] })
    isMoveRecorded.set(false)
    hasReset = true
    recordingMode.set(false)
    replayMode.set(false)
    resetBullets()
  }
</script>

<div class="pointer-events-auto" style="justify-content: space-between;">
  {#if $isEnded}
    <GameFinished />
  {:else}
    <InGameOverlay />

    {#if isRecorded && !$replayMode}
      <Banner>
        <div class="flex flex-col items-center">
          <h1 class="text-4xl font-black text-white">Time is up!</h1>
          <div class="flex justify-around mt-4">
            <Button
              on:click={reset}
              class="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Eraser class="inline-block" />
              <div>Reset</div>
            </Button>
            <Button
              on:click={setReplayMode}
              class="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Repeat class="inline-block" />
              <div>Replay</div>
            </Button>
            <Button
              on:click={moveHandler}
              class="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Send class="inline-block" />
              Submit Move
            </Button>
          </div>
        </div>
      </Banner>
      <!--<div
      class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-auto"
    >
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
        on:click={moveHandler}
      >
        Submit Move
      </button>
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
        on:click={reset}
      >
        Reset
      </button>
      {#if !$replayMode}
        <button
          class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
          on:click={setReplayMode}
        >
          Replay
        </button>
      {/if}

    </div>
          -->
    {:else if !$recordingMode && !$replayMode && $isTurnPlayer && !justRecorded}
      <Banner color="#65a30d">
        <div class="flex flex-col items-center">
          <h1 class="text-4xl font-black text-white">Your turn!</h1>
          <div class="flex justify-around mt-4">
            <Button
              on:click={setRecordingMode}
              class="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              Play
            </Button>
          </div>
        </div>
      </Banner>
    {:else if !$isTurnPlayer || justRecorded}
      <WaitingForTurn />
    {/if}

    <StartGame />
  {/if}
</div>
