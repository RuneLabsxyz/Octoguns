<script lang="ts">
  import { cn } from '$lib/css/cn'
  import Background from '$lib/ui/Background.svelte'
  import type { Snippet } from 'svelte'
  import { slide } from 'svelte/transition'

  let {
    color = '',
    children,
  }: {
    color?: string
    children?: Snippet
  } = $props()
</script>

<div
  class="fixed top-0 left-0 w-screen h-screen overflow-clip flex items-center flex-col justify-center pointer-events-none"
>
  <div
    class="relative flex w-full justify-center h-min overflow-clip py-10 border-y-4 border-black pointer-events-auto"
    transition:slide
  >
    <div>
      {@render children?.()}
    </div>

    <Background
      class={cn('brightness-[20%] opacity-80 contrast-[70%]', {
        'brightness-75': color != '',
      })}
      absolute={true}
      slow={true}
      {color}
    />
  </div>
</div>
