<script lang="ts">
  import { createEventDispatcher } from 'svelte'
  import { cn } from '$lib/css/cn'
  import { clickSound } from '$lib/3d/utils/audioUtils'

  export let inline = false
  export let small = false
  export let href: string | undefined = undefined
  export let selected = false
  export let className: string = ''

  const dispatcher = createEventDispatcher()

  let classes = ''
  $: classes = cn(
    'box-border border-4 border-black rounded-lg hover:bg-gray-300 btn shadow-md text-center',
    className,
    {
      'm-2': !inline,
      'px-5 py-2': !small,
      'bg-lime-100 hover:bg-lime-100 selected': selected,
    }
  )

  function handleClick(event: MouseEvent) {
    clickSound()
    dispatcher('click', event)
  }
</script>

{#if href}
  <a {href} on:click={handleClick} class={classes}>
    <slot></slot>
  </a>
{:else}
  <button on:click={handleClick} class={classes}>
    <slot></slot>
  </button>
{/if}

<style>
  .btn {
    transition: all 0.3s;
  }

  .btn:hover {
    box-shadow: black 6px 3px;
  }

  .selected {
    box-shadow: black 6px 3px;
  }
</style>
