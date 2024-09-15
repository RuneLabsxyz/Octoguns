import { writable } from 'svelte/store'

export const birdView = writable<boolean>(true)
export const inPointerLock = writable<boolean>(false)

