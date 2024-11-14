<script lang="ts">
  import Button from '$lib/ui/Button.svelte'
  import ControllerModal from '$lib/ui/ControllerModal.svelte'
  import { onMount } from 'svelte'
  import { connect } from '$lib/controller'
  import { controllerMainnet, controllerSlot } from '$lib/controller'
  import { username, account } from '$stores/account'
  import { env } from '$stores/network'
  interface Props {
    children?: import('svelte').Snippet
  }

  let { children }: Props = $props()

  let loading = $state(true)
  let showControllerModal = $state(false)

  onMount(async () => {
    /*
    if ( $env === "mainnet") {
      if (await controllerMainnet.probe()) {
        // auto connect
        await connect("mainnet");
     }    
    } else {
      if (await controllerSlot.probe()) {
        // auto connect
        await connect("slot");
      }
    }
    */
    loading = false
  })

  function toggleControllerModal() {
    showControllerModal = !showControllerModal
  }
</script>

<div class="wrapper w-screen h-screen flex items-stretch md:flex-row flex-col">
  <div
    class="flex flex-col m-7 bg-white border-4 border-black rounded-lg md:min-w-[15rem]"
  >
    {#if loading}
      <p>Loading</p>
    {/if}
    {#if $username && $account}
    <Button on:click={toggleControllerModal}>
      <img src="/logos/controller/controller.png" alt="Controller" class="inline-block w-8 h-8" />
      {$username}
    </Button>
  {/if}
  {#if !$username && !$account}
    <Button on:click={ () => connect('sepolia')}>
      <img src="/logos/controller/controller.png" alt="Controller" class="inline-block w-8 h-8" />
      Connect Wallet
      </Button>
    {/if}
    <Button href={`/${$env}/client/matchmaking`}>Matchmaking</Button>
    <Button href={`/${$env}/client/games/openGames`}>New Game</Button>
    <Button href={`/${$env}/client/games/yourGames`}>Your Games</Button>
    <Button href={`/${$env}/client/maps`}>Maps</Button>
    <div class="flex-grow"></div>
    <Button href="/">Back to home screen</Button>
  </div>
  <div class="m-7 md:ml-0 bg-white flex-grow border-4 border-black rounded-lg">
    {@render children?.()}
  </div>
</div>

<ControllerModal show={showControllerModal} on:close={toggleControllerModal} />

<style>
  .wrapper {
    background: url('/tiled-design.svg') repeat;

    background-size: 450px;
  }
</style>
