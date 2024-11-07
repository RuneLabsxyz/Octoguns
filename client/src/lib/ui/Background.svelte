<script lang="ts">
  import { cn } from '$lib/css/cn'


  interface Props {
    absolute?: boolean;
    slow?: boolean;
    color?: string;
    class?: string;
  }

  let {
    absolute = false,
    slow = false,
    color = '',
    class: className = ''
  }: Props = $props();
  
</script>

<div
  class={cn('bg ' + className, {
    fixed: !absolute,
    absolute: absolute,
    slow: slow,
    colored: color !== '',
  })}
  style="--color: {color};"
></div>

<style>
  .absolute {
    position: absolute;
  }
  .fixed {
    position: fixed;
  }

  .bg.slow {
    --time: 30s;
  }

  .bg.colored {
    background-image: linear-gradient(var(--color), var(--color)),
      url('/tiled-design.svg');
    background-blend-mode: multiply;
  }

  .bg {
    --size-x: 400px;
    --size-y: 349px;

    --time: 10s;

    background: url('/tiled-design.svg');

    background-repeat: repeat;
    background-size: var(--size-x);

    overflow: clip;

    top: calc(-1.5 * var(--size-y));
    left: calc(-1.5 * var(--size-x));

    width: calc(100vw + (var(--size-x) * 2));
    height: calc(100vh + (var(--size-y) * 2));

    animation: slide var(--time) linear infinite;

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
