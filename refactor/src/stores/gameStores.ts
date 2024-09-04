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

function normalizeCoords(coords: Coords): Coords {
    return {
        x: ((coords.x - 100) / 100) - 50,
        y: ((coords.y - 100) / 100) - 50,
    };
}

export function setPlayerCharacterCoords(key: number, coords: { x: number, y: number }): void {
    const normalizedCoords = normalizeCoords(coords);
    playerCharacterCoords.update(store => {
      return {
        ...store,
        [key]: normalizedCoords
      };
    });
}

export function setEnemyCharacterCoords(key: number, coords: { x: number, y: number }): void {
    const normalizedCoords = normalizeCoords(coords);
    enemyCharacterCoords.update(store => {
      return {
        ...store,
        [key]: normalizedCoords
      };
    });
}
