import { writable } from "svelte/store";


// Game meta data
export const gameState = writable<number>();
export const sessionId = writable<number>();

//characters
export const characterIds = writable<number[]>([]);

//true for recording, false for replaying
export const recordingMode = writable<boolean>(false);
export const replayMode = writable<boolean>(false);

export const recordedMove = writable<TurnData>( {
  sub_moves: [],
  shots: []
});

export const frameCounter = writable<number>();

export type TurnData = {
	sub_moves: {x: number, y: number, xdir: boolean, ydir: boolean}[],
	shots: {index: number, angle: number}[]
}

export const keyStateStore = writable<{
    w: boolean,
    a: boolean,
    s: boolean,
    d: boolean,
    forward: boolean,
    backward: boolean,
    left: boolean,
    right: boolean,
  }>({
    w: false,
    a: false,
    s: false,
    d: false,
    forward: false,
    backward: false,
    left: false,
    right: false,
  });

  export const isMouseDownStore = writable<boolean>(false);


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

