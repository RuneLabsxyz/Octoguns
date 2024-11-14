<script lang="ts">
</script>

<div class="background -z-10">
  <img src="/sprites/background.png" alt="bg" />
</div>

<style>
  .background {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
  }

  .background img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: bottom;
  }

  body,
  html {
    margin: 0;
    height: 100%;
    overflow: hidden;
  }
</style>
