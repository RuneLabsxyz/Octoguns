<script lang="ts">
  import { T } from '@threlte/core'
  import type { Character } from '$lib/api/data/characters'
  import type { Readable } from 'svelte/store'
  import getGame from '$lib/api/svelte/context'

  const {
    character,
  }: {
    character: Readable<Character | null>
  } = $props()

  const { currentPlayerId } = getGame()

  //TODO(Red): Is this correct?
  const isAlly = $derived(Number($character?.playerId) == $currentPlayerId)
</script>

{#if $character != null}
  <T.Mesh
    position={[$character.coords.x, 0, $character.coords.y]}
    key={$character.id}
  >
    <T.BoxGeometry args={[1, 1, 1]} />
    <T.MeshStandardMaterial color={isAlly ? 'blue' : 'red'} />
  </T.Mesh>
{/if}
