<script lang="ts">
  import { goto } from '$app/navigation'
  import Background from '$lib/ui/Background.svelte'
  import Button from '$lib/ui/Button.svelte'
  import { isSetup } from '$stores/dojoStore'
  import { playSoundEffectLoop } from '$lib/3d/utils/audioUtils'
  import { onMount } from 'svelte'
  import Controller from '@cartridge/controller';
  import { account, username } from '$stores/account';


  let mapmakerContract = '0x11e7a657668ca83c556f7545ab5bde00c1a1275c6c9ed17bea33104fcda2f3b'
  let spawnContract = '0x57a72dd6f0bf3b0ced0fd50e54696643b8e3b38e226a150a1471c658355921e'
  let startContract = '0x44ce069fe53c5c7941eec521bc9e876907d5da6ca273a98b78f1cbbcfea5b62'
  let actionsContract = '0x11de1871e7fa8ac97e62c36724c32ee584982f4a5892b4f62fd545d7ab2d506'

  let controller = new Controller({
    policies: [
      {
        target: startContract,
        method: 'create'
      },
      {
        target: startContract,
        method: 'create_closed'
      },
      {
        target: startContract,
        method: 'join'
      },
      {
        target: mapmakerContract,
        method: 'create'
      },
      {
        target: actionsContract,
        method: 'move'
      },
      {
        target: spawnContract,
        method: 'spawn'
      }
    ],
    rpc: "https://api.cartridge.gg/x/starknet/mainnet"
  })

  let loading: boolean = true;

  async function connect() {
		try {
			const res = await controller.connect();
			if (res) {
				account.set(controller.account);
				username.set(await controller.username());
			}
      goto('/client/games')
		} catch (e) {
			console.log(e);
		}
	}

	function disconnect() {
		controller.disconnect();
		account.set(undefined);
		username.set(undefined);
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
          {:else if $account}
            <Button on:click={() => goto('/client/games')}>Play</Button>
          {:else}
            <Button on:click={connect}>Connect</Button>
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

<style>
  .wrapper {
    background: url('/tiled-design.svg') repeat;
    background-size: 450px;
  }
</style>
