<script lang="ts">
  import { goto } from '$app/navigation'
  import Background from '$lib/ui/Background.svelte'
  import Button from '$lib/ui/Button.svelte'
  import { isSetup } from '$stores/dojoStore'
  import { playSoundEffectLoop } from '$lib/3d/utils/audioUtils'
  import { onMount } from 'svelte'
  import { connect } from '$lib/controller'
  let loading = true

  async function connectAndGoto() {
    await connect();
    goto('/client/games');
  }

  onMount(async () => {
    playSoundEffectLoop('/audio/tracks/underwater.flac', 0.5)
    loading = false;
  })
</script>

<Background />
<div class="">
  <div class="flex flex-col justify-center items-center h-screen">
    <div
      class="flex justify-center items-center flex-col bg-white p-10 rounded-lg border-black border-4"
    >
      <div class="text-9xl">
        <img src="/logos/LOGO_15.png" alt="OCTOGUNS" width="300" height="300" />
      </div>
      <div>
        {#if $isSetup}
          {#if loading}
          <p>Loading</p>
          {:else}
            <Button on:click={connectAndGoto}>Play</Button>
          {/if}
        {:else}
          <button class="p-5 pt-15" disabled>
            Sorry we are having issues with torii
          </button>
        {/if}
      </div>
    </div>
  </div>
</div>