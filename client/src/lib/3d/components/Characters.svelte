<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import { T } from '@threlte/core'
  import Character from './Character/Character.svelte'

  const { characters } = getGame()
</script>

<T.Group>
  {#each characters as character}
    <Character {character} />
  {/each}
</T.Group>
