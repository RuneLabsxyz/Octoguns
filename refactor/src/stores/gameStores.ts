import { writable } from "svelte/store";

export const gameState = writable<number>();
export const sessionId = writable<string>();