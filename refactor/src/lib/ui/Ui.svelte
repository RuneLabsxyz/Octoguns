<script lang="ts">
    import StartGame from "./StartGame.svelte";
    import { birdView } from "../../stores/cameraStores";
    import { recordingMode, replayMode } from "../../stores/gameStores";
    import { currentSubMove, recordedMove, isMoveRecorded, playerCharacterId, playerCharacterCoords, frameCounter } from "../../stores/gameStores";
    import { setPlayerCharacterCoords, setEnemyCharacterCoords } from "../../stores/gameStores";
    
    export let moveHandler: any;

    function setRecordingMode(e: Event) {
        recordingMode.set(!$recordingMode);
        replayMode.set(false);
    }

    function setReplayMode(e: Event) {
        recordingMode.set(false);
        frameCounter.set(0);
        setPlayerCharacterCoords($playerCharacterId, $playerCharacterCoords[$playerCharacterId].start);
        replayMode.set(!$recordingMode);
    }

    function reset(e: Event) {
        currentSubMove.set({x:0, y:0});
        setPlayerCharacterCoords($playerCharacterId, $playerCharacterCoords[$playerCharacterId].start);
        frameCounter.set(0);
        recordedMove.set({sub_moves: [], shots: []});
        isMoveRecorded.set(false);
        recordingMode.set(false);
        replayMode.set(false);
    }
    

</script>

<div class="pointer-events-auto" style="justify-content: space-between;">
    <button on:click={() => {console.log($birdView); birdView.set(!$birdView)}}>Switch view</button>
    {#if $isMoveRecorded}
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-auto">
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
    {:else}
        {#if !$recordingMode && !$replayMode}
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-auto">
                <button 
                class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
                on:click={setRecordingMode}
            >
                Record
            </button>
            </div>
        {/if}
    {/if}


    <StartGame />
</div>