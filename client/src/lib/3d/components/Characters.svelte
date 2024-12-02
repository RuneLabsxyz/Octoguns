<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import { T } from '@threlte/core'
  import Character from './Character/Character.svelte'
  import { get } from 'svelte/store'

  const { characters } = getGame()

  console.log('Characters', get(characters?.[0]))
</script>

<T.Group>
  {#each characters as character}
    <Character {character} />
  {/each}
</T.Group>
