import { keyStateStore, isMouseDownStore } from '$stores/gameStores'
import { get } from 'svelte/store'

export function handleKeyDown(event: KeyboardEvent) {
  let keyState = get(keyStateStore)
  if (
    event.key === 'w' ||
    event.key === 'a' ||
    event.key === 's' ||
    event.key === 'd'
  ) {
    keyState[event.key] = true
  }
  switch (event.key.toLowerCase()) {
    case 'w':
      keyState.forward = true
      break
    case 's':
      keyState.backward = true
      break
    case 'a':
      keyState.left = true
      break
    case 'd':
      keyState.right = true
      break
  }
  keyStateStore.set(keyState)
}

export function handleKeyUp(event: KeyboardEvent) {
  let keyState = get(keyStateStore)
  if (
    event.key === 'w' ||
    event.key === 'a' ||
    event.key === 's' ||
    event.key === 'd'
  ) {
    keyState[event.key] = false
  }
  switch (event.key.toLowerCase()) {
    case 'w':
      keyState.forward = false
      break
    case 's':
      keyState.backward = false
      break
    case 'a':
      keyState.left = false
      break
    case 'd':
      keyState.right = false
      break
  }
  keyStateStore.set(keyState)
}

export function handleMouseDown(event: MouseEvent) {
  if (event.button === 0) {
    // Left mouse button
    isMouseDownStore.set(true)
  }
}

export function handleMouseUp(event: MouseEvent) {
  if (event.button === 0) {
    // Left mouse button
    isMouseDownStore.set(false)
  }
}
