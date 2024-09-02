import { writable } from "svelte/store";
import { setupStore } from "./dojoStore";


export const availableSessions = writable([]);
export const mySessions = writable([]);