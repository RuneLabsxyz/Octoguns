import { writable } from "svelte/store";
import { createComponentValueStore } from "../dojo/componentValueStore";
import { setupStore } from "./dojoStore";


// Game meta data
export const gameState = writable<number>();
export const sessionId = writable<string>();

//characters
export const characterIds = writable<number[]>([]);