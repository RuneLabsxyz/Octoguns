<script>
    import { sideViewMode } from 'src/stores'; // Ensure you export this from your store file
    
    function toggleSideView() {
        sideViewMode.update(mode => !mode);
    }
</script>

<div class="toggle-view-container">
    <button on:click={toggleSideView}>
        {#if $sideViewMode}
            Switch to Multi-Camera View
        {:else}
            Switch to Side View Mode
        {/if}
    </button>
</div>

<style>
    .toggle-view-container {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 1000;
    }

    button {
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #45a049;
    }
</style>