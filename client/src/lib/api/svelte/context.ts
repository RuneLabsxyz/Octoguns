import { getContext, setContext } from 'svelte'
import type { GameStore } from '../game'
import type { GameState } from '../gameState'

/// In order to reduce the boilerplate needed to access the state of the game, this utility class exists to provide you with the current game data
// from *any* child of the components that calls the setGame function.

const CONTEXT_KEY = 'gameState'

export default function getGame(): GameState {
  return getContext(CONTEXT_KEY)
}

export function setGame(game: GameState) {
  setContext(CONTEXT_KEY, game)
}
