<script lang="ts">
  import Splitscreen from './Cameras/SplitScreen.svelte'
  import BirdView from './Cameras/BirdView.svelte'
  import { birdView } from '$stores/cameraStores'

  let birdViewValue: boolean

  $: birdViewValue = $birdView
</script>

{#if birdViewValue}
  <BirdView />
{/if}
{#if !birdViewValue}
  <Splitscreen />
{/if}
