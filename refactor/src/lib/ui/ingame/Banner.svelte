<script>
  import { cn } from '$lib/css/cn'
  import Background from '../Background.svelte'
  import { slide } from 'svelte/transition'

  export let important = false
</script>

<div
  class="fixed top-0 left-0 w-screen h-screen overflow-clip flex items-center flex-col justify-center pointer-events-none"
>
  <div
    class="relative flex w-full justify-center h-min overflow-clip py-10 border-y-4 border-black pointer-events-auto"
    transition:slide
  >
    <div>
      <slot></slot>
    </div>

    <Background
      class={cn('brightness-[20%] opacity-80 contrast-[70%]', {
        'brightness-75': important,
      })}
      absolute={true}
      slow={true}
      color={important ? '#65a30d' : ''}
    />
  </div>
</div>
