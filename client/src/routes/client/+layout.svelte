<script lang="ts">
  // Import necessary  features for navigation
  import { page } from '$app/stores'
  import Button from '$lib/ui/Button.svelte'
  import Controller from '@cartridge/controller';
  import { account, username } from '$stores/account';
  import { onMount } from 'svelte';

  let worldContract = '0x07394cbe15c7edf7e944c73c4a53e62804e7e616e01ad9838eff890bb582403a'

  let controller = new Controller({
    policies: [
      {
        target: worldContract,
        method: 'approve'
      },
      {
        target: worldContract,
        method: 'move'
      },
      {
        target: worldContract,
        method: 'startGame'
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
		if (await controller.probe()) {
			// auto connect
			await connect();
		}
		loading = false;
	});
</script>

<div class="wrapper w-screen h-screen flex items-stretch md:flex-row flex-col">
  <div
    class="flex flex-col m-7 bg-white border-4 border-black rounded-lg md:min-w-[15rem]"
  >
  {#if loading}
    <p>Loading</p>
    {:else if $account}
      <Button on:click={disconnect}>Disconnect</Button>
    {:else}
      <Button on:click={connect}>Connect</Button>
    {/if}
    <Button href="/client/games">Play</Button>
    <Button href="/client/mapmaker">Maps</Button>
    <div class="flex-grow"></div>
    <Button href="/">Back to home screen</Button>
  </div>
  <div class="m-7 md:ml-0 bg-white flex-grow border-4 border-black rounded-lg">
    <slot />
  </div>

  <!--
  
    <nav class="flex flex-row p-4">
    <ul class="flex flex-row space-x-4">
      <li><a href="/client/games" class="p-2">Games</a></li>
      <li><a href="/client/mapmaker" class="p-2">Mapmaker</a></li>
      <li><a href="/client/myGames" class="p-2">My Games</a></li>
    </ul>
  </nav>

    <div class="p-4">
    <slot />
  </div>
  -->
</div>

<style>
  .wrapper {
    background: url('/tiled-design.svg') repeat;

    background-size: 450px;
  }
</style>
