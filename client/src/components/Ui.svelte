<script>
    import ToggleView from './Ui/ToggleView.svelte';
    import SelectionOverlay from './Ui/SelectionOverlay.svelte';
    import SubmitAction from './Ui/SubmitAction.svelte';
    import { sideViewMode, isYourTurn } from 'src/stores'; // Ensure you export this from your store file
  </script>
  
{#if !$isYourTurn}
  <div class="not-your-turn">Not your turn</div>
{/if}


<ToggleView />
<SubmitAction />
{#if !$sideViewMode}
  <SelectionOverlay />
{/if}

<style>
  .not-your-turn {
      position: absolute;
      top: 10px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 1001;
      background-color: rgba(0, 0, 0, 0.7);
      color: white;
      padding: 10px 20px;
      border-radius: 5px;
      font-weight: bold;
  }
</style>