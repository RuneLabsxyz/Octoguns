<script lang="ts">
  import { bullets } from '$stores/gameStores'
  import Bullet from './Bullet.svelte'
</script>

{#each $bullets as bullet (bullet)}
  <Bullet {bullet} />
{/each}
