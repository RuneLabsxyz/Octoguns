import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
import { Bullet } from "./dojo/typescript/models.gen";
import { SessionMeta } from "./dojo/typescript/models.gen";

export const bullets = writable<Bullet>();
export const current_session_id = writable<number>();
export const current_session = writable<SessionMeta>();



// Camera stores
export const camera_coords = writable<[number, number][]>([]);
export const sideViewMode = writable(false);
export const selectionMode = writable(true);
export const simMode = writable(false);
export const isYourTurn = writable(false);
export const player_number = writable(0); // 1 or 2

// SImulation
export const activeCameras = writable([]);
export const camera_angles = writable([]);
