<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import Bullet from './Bullet/Bullet.svelte'

  const { bullets } = getGame()

  $inspect($bullets)
</script>

{#each $bullets ?? [] as bullet}
  <Bullet {bullet} />
{/each}
