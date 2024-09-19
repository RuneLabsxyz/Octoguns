<script lang="ts">
  import { frameCounter } from '$src/stores/gameStores'
</script>

<div class="step-bar-container">
  <div class="step-bar" style="width: {100 - $frameCounter / 1.5}%"></div>
</div>

<style>
  .step-bar-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 10px;
    background-color: #ddd;
    z-index: 1000;
  }

  .step-bar {
    height: 100%;
    background-color: #4caf50;
    transition: width 0.1s linear;
  }
</style>
