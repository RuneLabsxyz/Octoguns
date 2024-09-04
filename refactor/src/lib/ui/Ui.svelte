<script lang="ts">
    import StartGame from "./StartGame.svelte";
    import { birdView } from "../../stores/cameraStores";
    
</script>

<div class="pointer-events-auto">
    <button on:click={() => {console.log($birdView); birdView.set(!$birdView)}}>Switch view</button>
    <StartGame />
</div>