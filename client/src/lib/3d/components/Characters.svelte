<script lang="ts">
  import {
    playerCharacterCoords,
    enemyCharacterCoords,
    type CoordsStore
  } from '$stores/coordsStores'
  import { T } from '@threlte/core'
  import Red_man from './models/PISTOL_WALK_MAN_RED.svelte'
  import Blue_man from './models/PISTOL_WALK_MAN_BLUE.svelte'

  let player_coords: CoordsStore
  let enemy_coords: CoordsStore

  $: player_coords = $playerCharacterCoords
  $: enemy_coords = $enemyCharacterCoords
</script>

<T.Group>
  <T.Group>
    {#each Object.entries(player_coords) as [key, data]}
      <Blue_man position={[data.x, 0, data.y]} scale={200} />
    {/each}
  </T.Group>
  <T.Group>
    {#each Object.entries(enemy_coords) as [key, data]}
      <Red_man position={[data.x, 0, data.y]} scale={200} />
    {/each}
  </T.Group>
</T.Group>
