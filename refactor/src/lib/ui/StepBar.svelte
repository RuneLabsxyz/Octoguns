<script lang="ts">
  import { frameCounter } from '$src/stores/gameStores'

  function getColor(frameCount: number) {
    let remaining = 150 - frameCount
    if (remaining < 25) {
      return '#ef4444'
    }
    if (remaining < 75) {
      return '#f59e0b'
    }
    return '#4caf50'
  }
</script>

<div class="step-bar-container">
  <div
    class="step-bar"
    style="width: {100 - $frameCounter / 1.5}%; background-color: {getColor(
      $frameCounter
    )}"
  ></div>
</div>

<style>
  .step-bar-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 10px;
    background-color: transparent;
    z-index: 1000;
  }

  .step-bar {
    height: 100%;
    background-color: #4caf50;
    transition: width 0.1s linear;
  }
</style>
