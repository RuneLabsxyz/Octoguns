<script>
    import ToggleView from '../Ui/ToggleView.svelte';
    import SelectionOverlay from '../Ui/SelectionOverlay.svelte';
    import { sideViewMode } from 'src/stores'; // Ensure you export this from your store file
  </script>
  
<ToggleView />

{#if !$sideViewMode}
  <SelectionOverlay />
{/if}