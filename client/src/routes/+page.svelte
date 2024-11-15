<script lang="ts">
  import { goto } from '$app/navigation';
  import Background from '$lib/ui/Background.svelte';
  import Button from '$lib/ui/Button.svelte';
  import { playSoundEffectLoop } from '$lib/3d/utils/audioUtils';
  import { onMount } from 'svelte';
  import { connect } from '$lib/controller';
  import { account } from '$stores/account';
  import { env } from '$stores/network';
  import { initializeStore } from '$stores/dojoStore'

  async function initStore() {
    try {
      await initializeStore(true);
      console.log('Store initialized');
    } catch (error) {
      console.error('Failed to initialize store:', error);
    }
  }

  async function connectAndGoto(config: string) {
    env.set(config as "mainnet" | "slot" | "sepolia");
    await initStore();
    if (!$account) {
        await connect(config);
     }    
    goto(`${config}/client/matchmaking`);
  }

  onMount(() => {
    playSoundEffectLoop('/audio/tracks/underwater.flac', 0.5);
  });
</script>

<Background />
<div class="">
  <div class="flex flex-col justify-center items-center h-screen">
    <div class="flex justify-center items-center flex-col bg-white p-10 rounded-lg border-black border-4">
      <div class="text-9xl">
        <img src="/logos/LOGO_15.png" alt="OCTOGUNS" width="300" height="300" />
      </div>
      <div>
          <Button on:click={() => connectAndGoto('sepolia')}>Play Sepolia</Button>
      </div>
    </div>
  </div>
</div>