import { writable } from "svelte/store";
import { SetupResult } from "./dojo/setup";
import { Bullet } from "./dojo/typescript/models.gen";
import { SessionMeta } from "./dojo/typescript/models.gen";

export const bullets = writable<Bullet>();
export const current_session_id = writable<number>();
export const current_session = writable<SessionMeta>();
export const camera_coords = writable<[number, number][]>([]);
export const sideViewMode = writable(false);
