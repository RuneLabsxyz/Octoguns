<script lang="ts">
  import { T } from '@threlte/core'
  import type { Character } from '$lib/api/data/characters'
  import type { Readable } from 'svelte/store'
  import getGame from '$lib/api/svelte/context'
  import { SCALING_FACTOR } from '$lib/consts'
  import { accountStore } from '$src/stores/dojoStore'
  import { areAddressesEqual } from '$lib/helper'
  import type { Position } from '$lib/api/gameState'
  import { get } from 'svelte/store'

  const {
    character,
  }: {
    character: Readable<Character | null>
  } = $props()

  const { currentPlayerId } = getGame()

  //TODO(Red): Is this correct?
  const isAlly = $derived(
    areAddressesEqual(
      String(get(character)?.playerId),
      $accountStore?.address ?? BigInt(0)
    )
  )

  function normalizeCoords(coords: Position): Position {
    return {
      x: coords.x / 1000 - 50,
      y: coords.y / 1000 - 50,
    }
  }

  const normalizedCoordinates = $derived(
    normalizeCoords($character?.coords ?? { x: 0, y: 0 })
  )

  const position: [number, number, number] = $derived(
    $character
      ? [normalizedCoordinates.x, 0, normalizedCoordinates.y]
      : [0, 0, 0]
  )
</script>

{#if $character != null}
  <T.Mesh {position} key={$character.id}>
    <T.BoxGeometry args={[1, 1, 1]} />
    <T.MeshStandardMaterial color={isAlly ? 'blue' : 'red'} />
  </T.Mesh>
{/if}
