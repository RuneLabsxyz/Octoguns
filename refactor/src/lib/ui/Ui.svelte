<script lang="ts">
  import StartGame from './StartGame.svelte'
  import YouWin from './YouWin.svelte'
  import { birdView } from '$stores/cameraStores'
  import { recordingMode, replayMode } from '$stores/gameStores'
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
  export let moveHandler: any

  let isRecorded: boolean

  $: if (isMoveRecorded) isRecorded = $isMoveRecorded

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
    recordingMode.set(false)
    replayMode.set(false)
    resetBullets()
  }
</script>

<div class="pointer-events-auto" style="justify-content: space-between;">
  <button
    on:click={() => {
      birdView.update((value) => !value)
    }}>Switch view</button
  >
  {#if isRecorded}
    <div
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
  {:else if !$recordingMode && !$replayMode && $isTurnPlayer && $gameState != 1}
    <div
      class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-auto"
    >
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
        on:click={setRecordingMode}
      >
        Record
      </button>
    </div>
  {/if}

  <StartGame />
  <YouWin />
  <StepBar />
</div>
