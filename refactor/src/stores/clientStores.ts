import { writable } from "svelte/store";
import { setupStore } from "./dojoStore";


export const availableSessions = writable<number[]>([]);
export const mySessions = writable<number[]>([]);