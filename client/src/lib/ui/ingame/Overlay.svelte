<script>
  interface Props {
    children?: import('svelte').Snippet;
  }

  let { children }: Props = $props();
</script>

<div class="w-screen h-screen fixed top-0 left-0 z-20">
  {@render children?.()}
</div>
