import { writable } from 'svelte/store'
import type { WebGLRenderer } from 'three'
export const birdView = writable<boolean>(true)
export const inPointerLock = writable<boolean>(false)

export const rendererStore = writable<WebGLRenderer | null>(null);
