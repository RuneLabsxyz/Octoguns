<script lang="ts">
  import { bulletRenderCoords, tempBullets, type BulletCoordsStore } from '$stores/gameStores'
  import Bullet from './Bullet/Bullet.svelte'

  let bullet_coords: BulletCoordsStore

  $: bullet_coords = $bulletRenderCoords
</script>

{#each Object.entries(bullet_coords) as [key, bullet]}
  <Bullet {bullet} />
{/each}

{#each $tempBullets as bullet}
  <Bullet {bullet} />
{/each}
