<script>
    import { sideViewMode } from 'src/stores'; // Ensure you export this from your store file
  
    function toggleSideView() {
      sideViewMode.update(mode => !mode);
    }
  </script>
  
  <button on:click={toggleSideView}>
    {#if $sideViewMode}
      Switch to Multi-Camera View
    {/if}
    {#if !$sideViewMode}
      Switch to Side View Mode
    {/if}
  </button>
  