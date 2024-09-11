import { Vector3 } from 'three'
import {
  keyStateStore,
  isMouseDownStore,
  recordedMove,
  currentSubMove,
  frameCounter,
  playerCharacterCoords,
  recordingMode,
  isMoveRecorded,
  replayMode,
} from '$stores/gameStores'
import { truncateToDecimals } from '$lib/helper.'
import type { TurnData } from '$stores/gameStores'
import { get } from 'svelte/store'
import type * as THREE from 'three'

const move_speed = 1 / 3
const moveDirection = new Vector3()

export function recordMove(camera: THREE.Camera, characterId: number) {
  if (get(keyStateStore).forward) moveDirection.z -= 1
  if (get(keyStateStore).backward) moveDirection.z += 1
  if (get(keyStateStore).left) moveDirection.x -= 1
  if (get(keyStateStore).right) moveDirection.x += 1

  if (moveDirection.length() > 0 || get(isMouseDownStore)) {
    moveDirection.normalize().multiplyScalar(move_speed)
    try {
      moveDirection.applyQuaternion(camera.quaternion)
    } catch {
      //No camera quaternion
    }
    moveDirection.x = truncateToDecimals(moveDirection.x, 2)
    moveDirection.z = truncateToDecimals(moveDirection.z, 2)
    moveDirection.y = 0

    playerCharacterCoords.update((coords) => {
      coords[characterId].x += moveDirection.x
      coords[characterId].y += moveDirection.z
      return coords
    })

    currentSubMove.update((subMove) => {
      subMove.x += moveDirection.x
      subMove.y += moveDirection.z
      return subMove
    })

    if (get(frameCounter) % 3 == 0) {
      let move = {
        x: Math.abs(Math.round(get(currentSubMove).x * 100)),
        y: Math.abs(Math.round(get(currentSubMove).y * 100)),
        xdir: get(currentSubMove).x >= 0,
        ydir: get(currentSubMove).y >= 0,
      }
      recordedMove.update((rm) => {
        rm.sub_moves.push(move)
        return rm
      })
      currentSubMove.set({ x: 0, y: 0 })
    }
    frameCounter.update((fc) => fc + 1)
  }

  if (get(frameCounter) == 300) {
    recordingMode.set(false)
    isMoveRecorded.set(true)
    console.log(get(isMoveRecorded))
  }

  moveDirection.x = 0
  moveDirection.z = 0
}

export function replayMove(move: TurnData, characterId: number) {
  let move_index = Math.floor(get(frameCounter) / 3)
  let sub_move = move.sub_moves[move_index]

  if (get(frameCounter) == 300) {
    replayMode.set(false)
  }
  if (get(frameCounter) % 3 == 0 && get(frameCounter) < 300) {
    let x_dif = sub_move.x
    let y_dif = sub_move.y
    if (!sub_move.xdir) x_dif *= -1
    if (!sub_move.ydir) y_dif *= -1
    playerCharacterCoords.update((coords) => {
      coords[characterId].x += x_dif / 100
      coords[characterId].y += y_dif / 100
      return coords
    })
  }

  frameCounter.update((fc) => fc + 1)
}
