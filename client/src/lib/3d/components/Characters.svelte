<script lang="ts">
  import getGame from '$lib/api/svelte/context'
  import { T } from '@threlte/core'
  import Character from './Character/Character.svelte'
  import { get } from 'svelte/store'

  const { characters } = getGame()
  console.log(getGame())

  characters?.forEach((character) => {
    console.log('Characters', get(character))
  })

  
</script>

<T.Group>
  {#each characters as character}
    <Character {character} />
  {/each}
</T.Group>
