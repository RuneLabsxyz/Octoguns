<script lang="ts">
  import { CharactersStore } from '$lib/api/data/characters'
  import getGame from '$lib/api/svelte/context'
  
  let { currentPlayerId, currentPlayerCharacterIds, move, currentCharacters } = getGame()

  // Track selected characters
  let selectedCharacters: number[] = $state([])

  // Toggle character selection
  function toggleCharacter(characterId: number) {
    if (selectedCharacters.includes(characterId)) {
      selectedCharacters = selectedCharacters.filter(id => id !== characterId)
    } else {
      selectedCharacters = [...selectedCharacters, characterId]
    }
  }

  // Confirm selection and add characters
  function confirmSelection() {
    selectedCharacters.forEach(id => {
      move.addCharacter(id)
    })
    selectedCharacters = []
  }
</script>

<div class="character-select">
  <h2>Select Characters for Action</h2>
  
  {#if $currentCharacters && $currentCharacters.length > 0}
    <div class="character-grid">
      {#each $currentCharacters as character}
        <button
          class="character-card"
          class:selected={selectedCharacters.includes(character.id)}
          on:click={() => toggleCharacter(character.id)}
        >
          <div class="character-info">
            <span class="character-name">Character #{character.id}</span>
            <div class="character-stats">
              <span>Position: ({character.coords.x.toFixed(1)}, {character.coords.y.toFixed(1)})</span>
            </div>
            {#if selectedCharacters.includes(character.id)}
              <div class="selected-indicator">✓</div>
            {/if}
          </div>
        </button>
      {/each}
    </div>

    <div class="action-buttons">
      <button 
        class="confirm-button" 
        on:click={confirmSelection}
        disabled={selectedCharacters.size === 0}
      >
        Confirm Selection ({selectedCharacters.size} selected)
      </button>
    </div>
  {:else}
    <p>No characters available</p>
  {/if}
</div>

<style>
  .character-select {
    padding: 1rem;
    max-width: 1200px;
    margin: 0 auto;
  }

  h2 {
    color: #fff;
    margin-bottom: 1rem;
    text-align: center;
  }

  .character-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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

  .character-name {
    font-size: 1.2rem;
    font-weight: bold;
  }

  .character-stats {
    font-size: 0.9rem;
    color: #aaa;
  }

  .selected-indicator {
    font-size: 1.2rem;
    color: #4caf50;
    margin-top: 0.5rem;
  }

  .action-buttons {
    display: flex;
    justify-content: center;
    margin-top: 1rem;
  }

  .confirm-button {
    background: #4caf50;
    color: #fff;
    border: none;
    border-radius: 4px;
    padding: 0.75rem 1rem;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .confirm-button:hover {
    background: #45a049;
  }

  .confirm-button:disabled {
    background: #ccc;
    cursor: not-allowed;
  }
</style>
