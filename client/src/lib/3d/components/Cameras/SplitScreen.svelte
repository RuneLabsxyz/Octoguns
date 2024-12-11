<script lang="ts">
  import { T } from '@threlte/core'
  import { PerspectiveCamera } from 'three'
  import PointerLock from './SplitScreen/PointerLock.svelte'

  import { birdView } from '$stores/cameraStores'
  import { useThrelte } from '@threlte/core'
  import Hand from '../models/hand.svelte'
  import getGame from '$lib/api/svelte/context'
  import type { Position } from '$lib/api/gameState'
  import { onDestroy } from 'svelte'

  let { currentCharacters } = getGame()

  let playerCoords: Position[] | undefined = $state(undefined)
  let numCameras = $state(1)
  // Red: For some reason the object is not reactive if I do not subscribe manually
  const unsubscribe = currentCharacters.subscribe((chars) => {
    playerCoords = chars?.map((c) => c.coords)
    numCameras = chars?.length ?? 1
  })

  onDestroy(unsubscribe)

  function normalizeCoords(coords: Position): Position {
    return {
      x: coords.x / 1000 - 50,
      y: coords.y / 1000 - 50,
    }
  }

  let normalizedPlayerCoords: Position[] = $derived(
    playerCoords!.map((coords) => normalizeCoords(coords)) ?? [{ x: 0, y: 0 }]
  )
  $inspect(normalizedPlayerCoords)

  interface Props {
    cameras?: PerspectiveCamera[]
    numCameras?: number
  }

  let { cameras = $bindable([]) }: Props = $props()
</script>

{#if !$birdView}
  <PointerLock {cameras} />
{/if}

{#each Array(numCameras) as _, index}
  <T.PerspectiveCamera
    position={[normalizedPlayerCoords[index].x, 1, normalizedPlayerCoords[index].y]}
    oncreate={(obj) => {
      console.log('plz')
      cameras[index] = obj
      obj.lookAt(0, 1, 0)
    }}
  >
    <Hand position={[0.1, -0.16, -0.6]} rotation={[0, Math.PI, 0]} />
  </T.PerspectiveCamera>
{/each}
