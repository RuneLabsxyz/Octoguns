<script lang="ts">
  // Import necessary  features for navigation
  import { page } from '$app/stores'
  import Button from '$lib/ui/Button.svelte'
  import Controller from '@cartridge/controller';
  import { account, username } from '$stores/account';
  import { onMount } from 'svelte';


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
		} catch (e) {
			console.log(e);
		}
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
