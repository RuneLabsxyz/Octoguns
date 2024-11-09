<script lang="ts">
  import type { Snippet } from 'svelte'

  let {
    children,
  }: {
    children?: Snippet
  } = $props()
</script>

<div class="w-screen h-screen fixed top-0 left-0 z-20">
  {@render children?.()}
</div>
