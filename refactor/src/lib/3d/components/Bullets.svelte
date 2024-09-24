<script lang="ts">
  import { bulletRender, bulletInitialPosition } from '$stores/coordsStores'
  import Bullet from './Bullet/Bullet.svelte'

  $: bulletPairs = $bulletRender.map((bullet) => {
    const initialBullet = $bulletInitialPosition.find((b) => b.id === bullet.id)
    return { bullet, initialBullet }
  })
</script>

{#each bulletPairs as { bullet, initialBullet } (bullet.id)}
  <Bullet {bullet} initialPosition={initialBullet} />
{/each}
