import {
  SUBMOVE_SCALE,
  SCALING_FACTOR,
  FRAME_INTERVAL,
  RECORDING_FRAME_LIMIT,
  TURN_COUNT,
} from '$lib/consts'
import { clamp, normalizeAndScaleVector } from '$lib/helper'
import { birdView, inPointerLock } from '$src/stores/cameraStores'
import {
  type Readable,
  type Writable,
  get,
  readonly,
  writable,
} from 'svelte/store'
import { Camera, PerspectiveCamera, Vector3 } from 'three'
import * as THREE from 'three'
import { type KeyState, ControlsStore } from '../controls/controls'
import type { Marked, Position } from '../gameState'
import type { Character } from './characters'
import { rendererStore } from '$src/stores/gameStores'
import { getDojoContext } from '$src/stores/dojoStore'
import { truncate, getYawAngle, inverseMapAngle } from '$lib/helper'
import type { Bullet } from '$src/dojo/models.gen'

export type Submove = { x: number; y: number; xdir: boolean; ydir: boolean }
export type Shot = { angle: number; step: number }

export type TurnData = {
  sub_moves: Submove[]
  shots: Shot[]
}

function denormalizeCoords(coords: Position): Position {
  return {
    x: (coords.x + 50) * 100,
    y: (coords.y + 50) * 100,
  }
}

type Context = {
  incrementFrame: () => void
  addMove: (move: Submove) => void
  addShot: (shot: Shot) => void
  addAdditionalBullet: (bullet: Bullet) => void
  keyStateStore: Readable<KeyState>
  isMouseDownStore: Readable<boolean>
  hasShot: Writable<boolean>
  characterStore: Writable<Marked<Character> | null>
  currentSubmoveStore: Writable<Position>
  frameCounterStore: Readable<number>
  recordedMoveStore: Readable<TurnData>
  currentPlayerIdStore: Readable<number | null>
  currentTurnStore: Readable<number | null>
}

function shoot(ctx: Context, camera: PerspectiveCamera) {
  if (!camera || !camera.isCamera) {
    console.error('Invalid camera object')
    return
  }

  const frame = get(ctx.frameCounterStore)
  let move_index = Math.floor(frame / 3)

  let direction = getYawAngle(camera)
  if (direction < 0) {
    direction = 360 + direction
  }

  direction = Math.round(truncate(direction, 8) * 10 ** 8)

  console.log(
    `Bullet shot at move index ${move_index} with angle ${direction} degrees`
  )

  const bullet = { angle: direction, step: move_index }

  ctx.addShot(bullet)

  let vx = Math.cos(THREE.MathUtils.degToRad(direction / 10 ** 8))
  let vy = Math.sin(THREE.MathUtils.degToRad(direction / 10 ** 8))

  //
  const cameraPosition = camera.position
  // Create a temporary bullet for showing
  const newBullet: Bullet = {
    bullet_id: 0,
    shot_step: move_index + (get(ctx.currentTurnStore) ?? 0) * TURN_COUNT,
    shot_at: denormalizeCoords({
      x: cameraPosition.x,
      y: cameraPosition.z,
    }),
    velocity: { x: vx, y: vy, xdir: true, ydir: true },

    shot_by: get(ctx.currentPlayerIdStore) ?? 0,
  }

  ctx.addAdditionalBullet(newBullet)
}

function recordMove(ctx: Context, camera: Camera) {
  const moveDirection = new Vector3()
  const { forward, backward, left, right } = get<KeyState>(ctx.keyStateStore)
  const isMouseDown = get(ctx.isMouseDownStore)

  if (forward) moveDirection.z -= 1
  if (backward) moveDirection.z += 1
  if (left) moveDirection.x -= 1
  if (right) moveDirection.x += 1

  if (isMouseDown && get(inPointerLock) && !get(ctx.hasShot)) {
    shoot(ctx, camera as PerspectiveCamera)
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

    if (get<number>(ctx.frameCounterStore) % FRAME_INTERVAL === 0) {
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
  }

  // Reset move direction is not necessary since moveDirection is now scoped within the function
}

function replayShot(ctx: Context, camera: PerspectiveCamera) {
  let move: TurnData = get(ctx.recordedMoveStore)
  let frame = get(ctx.frameCounterStore)
  let move_index = Math.floor(frame / FRAME_INTERVAL)

  let shot = move.shots.find((shot) => shot.step === move_index)
  if (shot) {
    let angle = shot.angle

    console.log(`Bullet shot at move index ${move_index} with angle ${angle}`)

    let vx = Math.cos(THREE.MathUtils.degToRad(angle / 10 ** 8))
    let vy = Math.sin(THREE.MathUtils.degToRad(angle / 10 ** 8))

    const cameraPosition = camera.position
    // Create a temporary bullet for showing
    const newBullet: Bullet = {
      bullet_id: 0,
      shot_step: move_index + (get(ctx.currentTurnStore) ?? 0) * TURN_COUNT,
      shot_at: denormalizeCoords({
        x: cameraPosition.x,
        y: cameraPosition.z,
      }),
      velocity: { x: vx, y: vy, xdir: true, ydir: true },

      shot_by: get(ctx.currentPlayerIdStore) ?? 0,
    }

    ctx.addAdditionalBullet(newBullet)
  }
}

function replayMove(ctx: Context) {
  let move: TurnData = get(ctx.recordedMoveStore)
  let frame = get(ctx.frameCounterStore)
  let move_index = Math.floor(frame / FRAME_INTERVAL)
  if (move_index >= move.sub_moves.length) {
    console.warn('Move index exceeds recorded sub-moves.')
    return
  }
  let sub_move = move.sub_moves[move_index]
  console.log(move)

  if (frame % FRAME_INTERVAL === 0 && frame < RECORDING_FRAME_LIMIT) {
    let x_dif = sub_move.x
    let y_dif = sub_move.y
    if (!sub_move.xdir) x_dif *= -1
    if (!sub_move.ydir) y_dif *= -1

    ctx.characterStore.update((character) => {
      if (character == null) {
        return null
      }
      character.coords.x += x_dif / SCALING_FACTOR
      character.coords.y += x_dif / SCALING_FACTOR
      return character
    })
  }

  ctx.incrementFrame()
}

export type MoveStore = ReturnType<typeof MoveStore>

export function MoveStore(ctx: {
  controlsStore: ControlsStore
  currentCharacterStore: Writable<Marked<Character> | null>
  initialCharacterStore: Readable<Character | null>
  frameCounterStore: Readable<number>
  sessionIdStore: Readable<number>
  currentPlayerIdStore: Readable<number | null>
  currentTurnStore: Readable<number | null>
  incrementFrame: () => void
  resetFrameCounter: () => void
  addAdditionalBullet: (bullet: Bullet) => void
  resetAdditionalBullets: () => void
}) {
  const currentSubmoveStore = writable<Position>({
    x: 0,
    y: 0,
  })
  const recordedMoveStore = writable<TurnData>({
    shots: [],
    sub_moves: [],
  })

  // TODO: Encode this as a statemachine as some point
  const isRecordingStore = writable<boolean>(false)
  const isReplayingStore = writable<boolean>(false)
  const hasRecordedStore = writable<boolean>(false)
  const hasShotStore = writable<boolean>(false)

  const context: Context = {
    keyStateStore: ctx.controlsStore.keyStateStore,
    isMouseDownStore: ctx.controlsStore.isMouseDownStore,
    characterStore: ctx.currentCharacterStore,
    frameCounterStore: ctx.frameCounterStore,
    hasShot: hasShotStore,
    currentTurnStore: ctx.currentTurnStore,
    currentPlayerIdStore: ctx.currentPlayerIdStore,
    recordedMoveStore: readonly(recordedMoveStore),
    incrementFrame: ctx.incrementFrame,
    addAdditionalBullet: ctx.addAdditionalBullet,

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
        replayMove(context)
        replayShot(context, camera as PerspectiveCamera)

        // Increment frame counter
        ctx.incrementFrame()

        if (get(ctx.frameCounterStore) === RECORDING_FRAME_LIMIT) {
          ctx.resetFrameCounter()
          isReplayingStore.set(false)
        }
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
      ctx.resetFrameCounter()
      // Reset the positions to the one present on chain
      ctx.currentCharacterStore.set(get(ctx.initialCharacterStore))
      isReplayingStore.set(true)
    },

    reset() {
      ctx.resetFrameCounter()
      hasRecordedStore.set(false)
      isRecordingStore.set(false)
      isReplayingStore.set(false)
      hasShotStore.set(false)
      currentSubmoveStore.set({ x: 0, y: 0 })
      recordedMoveStore.set({
        shots: [],
        sub_moves: [],
      })
      ctx.resetAdditionalBullets()
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
