import { readonly, writable, type Writable } from 'svelte/store'

function handleKey(keyStateStore: Writable<any>, down: boolean) {
  return (event: KeyboardEvent) => {
    switch (event.key.toLowerCase()) {
      case 'w':
      case 'arrowup':
        keyStateStore.update((val) => {
          val.forward = down
          return val
        })
        break
      case 's':
      case 'arrowdown':
        keyStateStore.update((val) => {
          val.backward = down
          return val
        })
        break
      case 'a':
      case 'arrowleft':
        keyStateStore.update((val) => {
          val.left = down
          return val
        })
        break
      case 'd':
      case 'arrowright':
        keyStateStore.update((val) => {
          val.right = down
          return val
        })
        break
    }
  }
}

export type KeyState = {
  forward: boolean
  backward: boolean
  left: boolean
  right: boolean
}

export type ControlsStore = ReturnType<typeof ControlsStore>

export function ControlsStore() {
  const keyStateStore = writable<KeyState>({
    forward: false,
    backward: false,
    left: false,
    right: false,
  })

  const isMouseDownStore = writable<boolean>(false)

  return {
    keyStateStore: readonly(keyStateStore),
    isMouseDownStore: readonly(isMouseDownStore),

    // Handlers
    handleKeyDown: handleKey(keyStateStore, true),
    handleKeyUp: handleKey(keyStateStore, false),
    handleMouseDown: (event: MouseEvent) => {
      if (event.button === 0) {
        // Left mouse button
        isMouseDownStore.set(true)
      }
    },
    handleMouseUp: (event: MouseEvent) => {
      if (event.button === 0) {
        // Left mouse button
        isMouseDownStore.set(false)
      }
    },
  }
}
