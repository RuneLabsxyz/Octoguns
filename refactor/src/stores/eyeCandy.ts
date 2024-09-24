import { writable } from 'svelte/store'

export const splat = writable<{ x: number; y: number }[]>([])
