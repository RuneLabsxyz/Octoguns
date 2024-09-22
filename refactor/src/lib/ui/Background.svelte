<div class="bg"></div>

<style>
  .bg {
    --size-x: 400px;
    --size-y: 349px;

    background: url('/tiled-design.svg') repeat;
    background-size: var(--size-x);

    overflow: hidden;
    position: fixed;

    top: calc(-1.5 * var(--size-y));
    left: calc(-1.5 * var(--size-x));

    width: calc(100vw + (var(--size-x) * 2));
    height: calc(100vh + (var(--size-y) * 2));

    animation: slide 10s linear infinite;

    z-index: -10;
  }

  @keyframes slide {
    0% {
      transform: translate(0, 0);
    }
    100% {
      transform: translate(var(--size-x), var(--size-y));
    }
  }
</style>
