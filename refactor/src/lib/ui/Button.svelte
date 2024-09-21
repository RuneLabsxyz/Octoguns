<script>
  import { cn } from '$lib/css/cn'
  export let inline = false
  export let small = false
  export let href = undefined

  let classes = cn(
    'border-4 border-black rounded-lg  hover:bg-gray-300 btn shadow-md text-center',
    {
      'm-2': !inline,
      'px-5 py-2': !small,
    }
  )
</script>

{#if href}
  <a on:click {href} class={classes}>
    <slot></slot>
  </a>
{:else}
  <button on:click class={classes}>
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
</style>
