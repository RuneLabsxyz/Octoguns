<script lang="ts">
  import { Game } from '$lib/api/game'
  import { account } from '$stores/account'
  import { connect } from '$lib/controller'
  import { controllerMainnet, controllerSlot, controllerSepolia } from '$lib/controller'
  import { env } from '$stores/network'
  import { onMount } from 'svelte'
  import GameComponent from '$lib/ui/Game.svelte'

  let { data } = $props()

  const gameStorePromise = $state(Game(parseInt(data.gameId)))

  $effect(() => {
    console.log('gameStorePromise', data)
  })
  onMount(async () => {
    if ($env === 'mainnet') {
      if (await controllerMainnet.probe()) {
        // auto connect
        await connect('mainnet')
      }
    } 
    else if ($env === 'slot') {
      if (await controllerSlot.probe()) {
        // auto connect
        await connect('slot')
      }
    }
    else if ($env === 'sepolia') {
      if (await controllerSepolia.probe()) {
        // auto connect
        await connect('sepolia')
      }
    }
  })
  
</script>

{#await gameStorePromise}
  <p>Game is loading...</p>
{:then gameStore}
  <GameComponent {gameStore} />
{/await}
