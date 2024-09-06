<script lang="ts">
    import StartGame from "./StartGame.svelte";
    import { birdView } from "../../stores/cameraStores";
    import { recordingMode, replayMode } from "../../stores/gameStores";
    import { currentSubMove, recordedMove } from "../../stores/gameStores";
    
    function setRecordingMode(e: Event) {
        recordingMode.set(!$recordingMode);
        replayMode.set(false);
    }

    function setReplayMode(e: Event) {
        recordingMode.set(false);
        replayMode.set(!$recordingMode)
    }

    function reset(e: Event) {
        currentSubMove.set({x:0, y:0});
        recordedMove.set({sub_moves: [], shots: []});
    }


</script>

<div class="pointer-events-auto" style="justify-content: space-between;">
    <button on:click={() => {console.log($birdView); birdView.set(!$birdView)}}>Switch view</button>
    <button on:click={setRecordingMode}> Record </button>
    <button on:click={setReplayMode}> Replay </button>
    <button on:click={reset}> Reset </button>

    <StartGame />
</div>