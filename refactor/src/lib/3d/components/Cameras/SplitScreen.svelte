<script lang="ts">
  import { T } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import PointerLock from './SplitScreen/PointerLock.svelte'
  import { playerCharacterId } from '$stores/gameStores'
  import { playerCharacterCoords } from '$stores/coordsStores'
  import { birdView } from '$stores/cameraStores'
  import Hand from '../models/hand.svelte'

  $: playerCoords = $playerCharacterCoords[$playerCharacterId]

  export let cameras: PerspectiveCamera[] = []
  export let numCameras: number = 1
</script>

{#if !$birdView}
  <PointerLock {cameras} />
{/if}

{#each Array(numCameras) as _, index}
  <T.PerspectiveCamera
    position={[playerCoords.x, 1, playerCoords.y]}
    on:create={({ ref }) => {
      cameras[index] = ref
      ref.lookAt(0, 1, 0)
    }}
  >
    <!-- Position the hand 0.5 units in front of the camera -->
    <Hand position={[0.1, -0.16, -0.6]} rotation={[0, Math.PI, 0]} />
  </T.PerspectiveCamera>
{/each}
