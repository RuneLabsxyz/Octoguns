import { writable } from 'svelte/store'

export const availableSessions = writable<number[]>([])
export const mySessions = writable<number[]>([])
export const selectedMap = writable<number>(0)
