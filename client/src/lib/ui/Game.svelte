<script lang="ts">
  import { Canvas } from '@threlte/core'
  import Waiting from './ingame/Waiting.svelte'
  import Scene from '$lib/3d/Scene.svelte'
  import Ui from './Ui.svelte'
  import { setGame } from '$lib/api/svelte/context'
  import { GameState } from '$lib/api/gameState'
  import type { GameStore } from '$lib/api/game'

  const {
    gameStore,
  }: {
    gameStore: GameStore
  } = $props()

  setGame(GameState(gameStore))

  const { session } = gameStore
</script>

{#if $session?.state === 0}
  <Waiting />
{/if}

<div class="absolute top-0 left-0 w-full h-full z-10 pointer-events-none">
  <Ui />
</div>
<div class="absolute h-full w-full">
  <Canvas>
    <Scene />
  </Canvas>
</div>
