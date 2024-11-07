<script lang="ts">
  import { run } from 'svelte/legacy';

  import { createEventDispatcher } from 'svelte'
  import { cn } from '$lib/css/cn'
  import { clickSound } from '$lib/3d/utils/audioUtils'

  interface Props {
    inline?: boolean;
    small?: boolean;
    href?: string | undefined;
    selected?: boolean;
    className?: string;
    children?: import('svelte').Snippet;
  }

  let {
    inline = false,
    small = false,
    href = undefined,
    selected = false,
    className = '',
    children
  }: Props = $props();

  const dispatcher = createEventDispatcher()

  let classes = $state('')
  run(() => {
    classes = cn(
      'box-border border-4 border-black rounded-lg hover:bg-gray-300 btn shadow-md text-center',
      className,
      {
        'm-2': !inline,
        'px-5 py-2': !small,
        'bg-lime-100 hover:bg-lime-100 selected': selected,
      }
    )
  });

  function handleClick(event: MouseEvent) {
    clickSound()
    dispatcher('click', event)
  }
</script>

{#if href}
  <a {href} onclick={handleClick} class={classes}>
    {@render children?.()}
  </a>
{:else}
  <button onclick={handleClick} class={classes}>
    {@render children?.()}
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
