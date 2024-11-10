import {
  SUBMOVE_SCALE,
  SCALING_FACTOR,
  FRAME_INTERVAL,
  RECORDING_FRAME_LIMIT,
} from '$lib/consts'
import { clamp, normalizeAndScaleVector } from '$lib/helper'
import { birdView, inPointerLock } from '$src/stores/cameraStores'
import type { Readable } from 'svelte/motion'
import { type Writable, get, readonly, writable } from 'svelte/store'
import { Camera, Controls, Vector3 } from 'three'
import { type KeyState, ControlsStore } from '../controls/controls'
import type { Marked, Position } from '../gameState'
import type { Character } from './characters'
import { frameCounter, rendererStore } from '$src/stores/gameStores'
import { CallData } from 'starknet'
import { getDojoContext } from '$src/stores/dojoStore'

export type Submove = { x: number; y: number; xdir: boolean; ydir: boolean }
export type Shot = { angle: number; step: number }

export type TurnData = {
  sub_moves: Submove[]
  shots: Shot[]
}

type Context = {
  keyStateStore: Readable<KeyState>
  isMouseDownStore: Readable<boolean>
  characterStore: Writable<Marked<Character> | null>
  currentSubmoveStore: Writable<Position>
  frameCounterStore: Readable<number>
  incrementFrame: () => void
  addMove: (move: Submove) => void
  addShot: (shot: Shot) => void
}

function recordMove(ctx: Context, camera: Camera) {
  const moveDirection = new Vector3()
  const { forward, backward, left, right } = get(ctx.keyStateStore)
  const isMouseDown = get(ctx.isMouseDownStore)

  if (forward) moveDirection.z -= 1
  if (backward) moveDirection.z += 1
  if (left) moveDirection.x -= 1
  if (right) moveDirection.x += 1

  if (isMouseDown && get(inPointerLock)) {
    // TODO(Red): Shoot!
  }

  if (moveDirection.length() > 0) {
    // Scale move direction and convert to integers using Math.round

    if (camera.quaternion) {
      moveDirection.applyQuaternion(camera.quaternion)
    } else {
      console.warn('Camera quaternion is undefined.')
    }

    // Normalize and scale the move direction to maintain consistent speed
    const normalized = normalizeAndScaleVector(
      moveDirection.x,
      moveDirection.z,
      SUBMOVE_SCALE / 3
    )
    moveDirection.x = normalized.x
    moveDirection.z = normalized.y

    // Ensure y-axis movement is zero (assuming 2D movement)
    moveDirection.y = 0

    // Update player coordinates with clamped values to stay within grid bounds
    ctx.characterStore.update((character) => {
      if (character == null) {
        return character
      }

      // Mark the character
      character.__marked = 'moved'

      const newX = character.coords.x + moveDirection.x / SCALING_FACTOR
      const newY = character.coords.y + moveDirection.z / SCALING_FACTOR

      // Check if new coordinates are out of bounds and set move direction to 0 if they are
      if (newX < -50 || newX > 50) {
        moveDirection.x = 0
      }
      if (newY < -50 || newY > 50) {
        moveDirection.z = 0
      }

      character.coords.x = clamp(newX, -50, 50)
      character.coords.y = clamp(newY, -50, 50)

      return character
    })

    ctx.currentSubmoveStore.update((subMove) => {
      subMove.x += moveDirection.x
      subMove.y += moveDirection.z
      return subMove
    })

    if (get(ctx.frameCounterStore) % FRAME_INTERVAL === 0) {
      const current = normalizeAndScaleVector(
        get(ctx.currentSubmoveStore).x,
        get(ctx.currentSubmoveStore).y,
        SUBMOVE_SCALE
      )

      let move = {
        x: Math.abs(current.x),
        y: Math.abs(current.y),
        xdir: current.x >= 0,
        ydir: current.y >= 0,
      }

      ctx.addMove(move)

      ctx.currentSubmoveStore.set({ x: 0, y: 0 })
    }

    // Increment frame counter
    ctx.incrementFrame()
  }

  // Reset move direction is not necessary since moveDirection is now scoped within the function
}

export type MoveStore = ReturnType<typeof MoveStore>

export function MoveStore(ctx: {
  controlsStore: ControlsStore
  currentCharacterStore: Writable<Marked<Character> | null>
  initialCharacterStore: Readable<Character | null>
  frameCounterStore: Readable<number>
  sessionIdStore: Readable<number>
  incrementFrame: () => void
}) {
  const currentSubmoveStore = writable<Position>()
  const recordedMoveStore = writable<TurnData>({
    shots: [],
    sub_moves: [],
  })

  // TODO: Encode this as a statemachine as some point
  const isRecordingStore = writable<boolean>(false)
  const isReplayingStore = writable<boolean>(false)
  const hasRecordedStore = writable<boolean>(false)

  const context: Context = {
    keyStateStore: ctx.controlsStore.keyStateStore,
    isMouseDownStore: ctx.controlsStore.isMouseDownStore,
    characterStore: ctx.currentCharacterStore,
    frameCounterStore: ctx.frameCounterStore,
    incrementFrame: ctx.incrementFrame,

    currentSubmoveStore: currentSubmoveStore,
    addMove(move) {
      recordedMoveStore.update((val) => {
        val.sub_moves.push(move)
        return val
      })
    },
    addShot(shot) {
      recordedMoveStore.update((val) => {
        val.shots.push(shot)
        return val
      })
    },
  }

  return {
    isRecording: readonly(isRecordingStore),
    isReplaying: readonly(isReplayingStore),
    hasRecorded: readonly(hasRecordedStore),

    currentSubmove: readonly(currentSubmoveStore),
    recordedMove: readonly(recordedMoveStore),

    update: (camera: Camera) => {
      if (get(isRecordingStore)) {
        recordMove(context, camera)

        // Stop the recording if finished
        if (get(ctx.frameCounterStore) === RECORDING_FRAME_LIMIT) {
          isRecordingStore.set(false)
          hasRecordedStore.set(true)
          document.exitPointerLock()
        }
      }

      if (get(isReplayingStore)) {
        // TODO: Replay the move
      }
    },

    startRecording() {
      isRecordingStore.set(true)
      birdView.set(false)
      isReplayingStore.set(false)
      inPointerLock.set(true)
      get(rendererStore).domElement.requestPointerLock()
    },

    replay() {
      isRecordingStore.set(false)
      // Reset the frame counter
      frameCounter.set(0)
      // Reset the positions to the one present on chain
      ctx.currentCharacterStore.set(get(ctx.initialCharacterStore))
      isReplayingStore.set(true)
    },

    reset() {
      frameCounter.set(0)
      hasRecordedStore.set(false)
      isRecordingStore.set(false)
      isReplayingStore.set(false)
      currentSubmoveStore.set({ x: 0, y: 0 })
      recordedMoveStore.set({
        shots: [],
        sub_moves: [],
      })
    },

    async submit() {
      // TODO: Handle the submit
      const callData = get(recordedMoveStore)
      console.log('callData', callData)
      const [account, { client }] = await getDojoContext()
      client.actions.move({
        account,
        session_id: get(ctx.sessionIdStore),
        //@ts-expect-error - This is just sad...
        moves: callData,
      })

      this.reset()
    },
  }
}
