<script lang="ts">
  import Button from '$lib/ui/Button.svelte'
  import { onMount } from 'svelte';
  import { connect } from '$lib/controller'
  import { controller } from '$lib/controller'
  import { username } from '$stores/account'
  let loading = true

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
    {/if}
    {#if username}
      <Button>
        <img src="/logos/controller/controller.png" alt="Controller" class="inline-block w-8 h-8" />
        {$username}
      </Button>
    {/if}
    <Button href="/client/games/openGames">New Game</Button>
    <Button href="/client/games/yourGames">Your Games</Button>
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
