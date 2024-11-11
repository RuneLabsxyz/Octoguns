import { writable, get } from 'svelte/store'
import { type Bullet } from '$src/dojo/models.gen'
import { WebGLRenderer } from 'three'

export const rendererStore = writable<WebGLRenderer>()