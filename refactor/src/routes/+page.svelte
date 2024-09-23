<script lang="ts">
  import { goto } from '$app/navigation'
  import Background from '$lib/ui/Background.svelte'
  import Button from '$lib/ui/Button.svelte'
  import { isSetup } from '$stores/dojoStore'
</script>

<Background />
<div class="">
  <div class="flex flex-col justify-center items-center h-screen">
    <div
      class="flex justify-center items-center flex-col bg-white p-10 rounded-lg border-black border-4"
    >
      <div class="text-9xl">
        <h1 class="font-Block">OCTO</h1>
        <h2 class="font-Block">GUNS</h2>
      </div>
      <div class="mt-8">
        {#if $isSetup}
          <Button on:click={() => goto('/client/games')}>Play</Button>
        {:else}
          <button class="p-5 pt-15" disabled>
            Sorry we are having issues with torii
          </button>
        {/if}
      </div>
    </div>
  </div>
</div>

<style>
  .wrapper {
    background: url('/tiled-design.svg') repeat;

    background-size: 450px;
  }
</style>
