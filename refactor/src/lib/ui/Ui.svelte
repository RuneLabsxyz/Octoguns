<script lang="ts">
    import StartGame from "./StartGame.svelte";
    import { birdView } from "../../stores/cameraStores";
    import { recordingMode, replayMode } from "../../stores/gameStores";
    
    function handleSwitch(e: Event) {
        recordingMode.set(!$recordingMode);
        replayMode.set(!$recordingMode);
        console.log($recordingMode)

    }
</script>

<div class="pointer-events-auto">
    <button on:click={() => {console.log($birdView); birdView.set(!$birdView)}}>Switch view</button>
    <button on:click={handleSwitch}> Switch To {$recordingMode ? "replay" : "recording"} mode </button>
    <StartGame />
</div>