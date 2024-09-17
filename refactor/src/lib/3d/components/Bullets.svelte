<script lang="ts">
  import { bulletRender} from '$stores/coordsStores'
  import Bullet from './Bullet/Bullet.svelte'

</script>

{#each $bulletRender as bullet (bullet)}
  <Bullet {bullet} />
{/each}
