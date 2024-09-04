import { writable } from "svelte/store";


// Game meta data
export const gameState = writable<number>();
export const sessionId = writable<number>();

//characters
export const characterIds = writable<number[]>([]);


interface Coords {
    x: number;
    y: number;
  }

type CharacterCoordsStore = Record<number, Coords>;

export const playerCharacterCoords = writable<CharacterCoordsStore>({});
export const enemyCharacterCoords = writable<CharacterCoordsStore>({});

export function setPlayerCharacterCoords(key: number, coords: { x: number, y: number }): void {
    playerCharacterCoords.update(store => {
      return {
        ...store,
        [key]: coords
      };
    });
}

export function setEnemyCharacterCoords(key: number, coords: { x: number, y: number }): void {
    enemyCharacterCoords.update(store => {
      return {
        ...store,
        [key]: coords
      };
    });
}