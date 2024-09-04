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

export const characterCoords = writable<CharacterCoordsStore>({});

export function setCharacterCoords(key: number, coords: { x: number, y: number }): void {
    characterCoords.update(store => {
      return {
        ...store,
        [key]: coords
      };
    });
  }