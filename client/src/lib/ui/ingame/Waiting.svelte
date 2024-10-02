<script lang="ts">
  import Background from '../Background.svelte'
  import Overlay from './Overlay.svelte'

  import facts from '$src/data/facts.json'
  import { onDestroy, onMount } from 'svelte'

  let fact = facts[Math.floor(Math.random() * facts.length)]
</script>

<Overlay>
  <Background />
  <div class="flex flex-col justify-center items-center h-screen">
    <div
      class="flex justify-center items-center flex-col bg-white p-10 rounded-lg border-black border-4"
    >
      <h1 class="text-3xl font-bold">Waiting for another player...</h1>
      <p class="mt-2">{fact}</p>
    </div>
  </div>
</Overlay>
