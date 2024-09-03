<script lang="ts">
    import StartGame from "./StartGame.svelte";
    
</script>

<div class="pointer-events-auto">
    <button on:click={() => console.log("Button press")}>button</button>
    <StartGame />
</div>