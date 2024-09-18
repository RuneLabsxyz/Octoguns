<script lang="ts">
  import { T } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import PointerLock from './SplitScreen/PointerLock.svelte'
  import { playerCharacterId } from '$stores/gameStores'
  import { playerCharacterCoords } from '$stores/coordsStores'
  import { birdView } from '$stores/cameraStores'

  $: playerCoords = $playerCharacterCoords[$playerCharacterId]

  export let cameras: PerspectiveCamera[] = []
  export let numCameras: number = 1
</script>

{#if !$birdView}
  <PointerLock {cameras} />
{/if}

{#each Array(numCameras) as _, index}
  <T.PerspectiveCamera
    position={[playerCoords.x, 5, playerCoords.y]}
    fov={90}
    on:create={({ ref }) => {
      cameras[index] = ref
      ref.lookAt(0, 5, 0)
    }}
  />
{/each}
