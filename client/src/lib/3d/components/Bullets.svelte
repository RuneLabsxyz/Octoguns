<script lang="ts">
  import { bulletRender, bulletInitialPosition } from '$stores/coordsStores'
  import Bullet from './Bullet/Bullet.svelte'

  let bulletPairs = $derived($bulletRender.map((bullet, index) => {
    console.log('bullet', bullet)
    const initialBullet = $bulletInitialPosition.find((b) => b.id === bullet.id)
    const uniqueKey = `${bullet.id}-${index}-${initialBullet?.coords.x}-${initialBullet?.coords.y}`
    return { bullet, initialBullet, uniqueKey }
  }))
</script>

{#each bulletPairs as { bullet, initialBullet, uniqueKey } (uniqueKey)}
  <Bullet {bullet} initialPosition={initialBullet} />
{/each}
