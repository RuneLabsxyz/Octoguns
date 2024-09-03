import { writable } from "svelte/store";


// Game meta data
export const gameState = writable<number>();
export const sessionId = writable<number>();

//characters
export const characterIds = writable<number[]>([]);