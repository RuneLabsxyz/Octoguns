<script lang="ts">
    import { Canvas } from "@threlte/core"
    import Game from '../Game.svelte'
</script>

<div class="container">
    <Canvas>
            <Game />
    </Canvas>
</div>

<style>
    .container {
        display: flex;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
    }

    :global(canvas) {
        width: 100%;
        height: 100%;
        display: block;
        cursor: pointer; /* Added line */
    }
</style>