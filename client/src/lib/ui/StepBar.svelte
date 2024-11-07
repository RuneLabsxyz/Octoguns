<script lang="ts">
  import { frameCounter } from '$src/stores/gameStores'
  import { RECORDING_FRAME_LIMIT } from '$src/lib/consts'

  function getColor(frameCount: number) {
    let remaining = RECORDING_FRAME_LIMIT - frameCount
    if (remaining < 25) {
      return '#ef4444'
    }
    if (remaining < 75) {
      return '#f59e0b'
    }
    return '#4caf50'
  }

  let barWidth = $derived(Math.max(0, 100 - ($frameCounter / RECORDING_FRAME_LIMIT) * 100))
</script>

<div class="step-bar-container">
  <div
    class="step-bar"
    style="width: {barWidth}%; background-color: {getColor($frameCounter)}"
  ></div>
</div>

<style>
  .step-bar-container {
    display: flex;
    margin-left: 0.5rem;
    border-top-left-radius: 2rem;
    background-color: #0f172a50;
    border: 2px solid black;
    border-right: none;
    border-bottom: none;
    width: calc(100% - 0.5rem);
    height: 100%;
    z-index: 1000;
    overflow: hidden;
  }

  .step-bar {
    height: 100%;
    background-color: #4caf50;

    --light-color: #4caf50;
    --darken-color: #49894b;

    background: repeating-linear-gradient(
      -45deg,
      var(--light-color),
      var(--light-color) 10px,
      var(--darken-color) 10px,
      var(--darken-color) 20px
    );

    transform: rotateY(180deg);
    transition: width 0.1s linear;
  }
</style>
