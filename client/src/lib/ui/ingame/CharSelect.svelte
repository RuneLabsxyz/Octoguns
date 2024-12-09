<script lang="ts">
  import { CharactersStore } from '$lib/api/data/characters'
  import { SessionMeta } from '$lib/api/sessionMeta'
  import { onMount } from 'svelte'
  import { derived, type Readable } from 'svelte/store'
  import getGame from '$lib/api/svelte/context'
  import type { Character } from '$lib/api/data/characters'
  import get from '$lib/api/utils'
  import { get as getValue } from 'svelte/store'
  
  let {currentPlayerId, currentPlayerCharacterIds, move, currentCharacters } = getGame()

  console.log($currentCharacters)
</script>

<div class="character-select">
  <h2>Select Your Character</h2>
  
  {#if $currentCharacters && $currentCharacters.length > 0}
    <div class="character-grid">
      {#each $currentCharacters as character}
        <button
          class="character-card"
          on:click={() => {
            //@ts-ignore
            move.addCharacter(character.id.value)
          }}
        >
          <div class="character-info">
            <span>Character #{character.id}</span>
          </div>
        </button>
      {/each}
    </div>
  {:else}
    <p>No characters available</p>
  {/if}
</div>

<style>
  .character-select {
    padding: 1rem;
  }

  .character-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1rem;
    margin-top: 1rem;
  }

  .character-card {
    background: #2a2a2a;
    border: 2px solid #444;
    border-radius: 8px;
    padding: 1rem;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .character-card:hover {
    transform: translateY(-2px);
    border-color: #666;
  }

  .character-info {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .position {
    font-size: 0.9rem;
    color: #aaa;
  }
</style>
