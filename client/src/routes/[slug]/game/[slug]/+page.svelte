<script lang="ts">
  import { Game } from '$lib/api/game'
  import { account } from '$stores/account'
  import { connect } from '$lib/controller'
  import { controllerMainnet, controllerSlot } from '$lib/controller'
  import { env } from '$stores/network'
  import { onMount } from 'svelte'
  import GameComponent from '$lib/ui/Game.svelte'

  let { data } = $props()

  const gameStorePromise = $state(Game(parseInt(data.gameId)))

  $effect(() => {
    console.log('gameStorePromise', data)
  })
  /*
  onMount(async () => {
    if ($env === 'mainnet') {
      if (await controllerMainnet.probe()) {
        // auto connect
        await connect('mainnet')
      }
    } else {
      if (await controllerSlot.probe()) {
        // auto connect
        await connect('slot')
      }
    }
  })
  */
</script>

{#await gameStorePromise}
  <p>Game is loading...</p>
{:then gameStore}
  <GameComponent {gameStore} />
{/await}
