import { Vector3 } from 'three'
import {
  keyStateStore,
  isMouseDownStore,
  recordedMove,
  currentSubMove,
  frameCounter,
  recordingMode,
  isMoveRecorded,
  replayMode,
} from '$stores/gameStores'

import { playerCharacterCoords } from '$stores/coordsStores'
import { inPointerLock } from '$stores/cameraStores'
import type { TurnData } from '$stores/gameStores'
import { get } from 'svelte/store'
import { Camera } from 'three'
import {
  SCALING_FACTOR,
  FRAME_INTERVAL,
  RECORDING_FRAME_LIMIT,
  SUBMOVE_SCALE,
} from '$lib/consts'
import { normalizeAndScaleVector, clamp } from '$lib/helper'

export function replayMove(move: TurnData, characterId: number) {
  if (get(frameCounter) === RECORDING_FRAME_LIMIT) {
    frameCounter.set(0)
    replayMode.set(false)
  }

  let move_index = Math.floor(get(frameCounter) / FRAME_INTERVAL)
  if (move_index >= move.sub_moves.length) {
    console.warn('Move index exceeds recorded sub-moves.')
    return
  }
  let sub_move = move.sub_moves[move_index]
  console.log(move)

  if (
    get(frameCounter) % FRAME_INTERVAL === 0 &&
    get(frameCounter) < RECORDING_FRAME_LIMIT
  ) {
    let x_dif = sub_move.x
    let y_dif = sub_move.y
    if (!sub_move.xdir) x_dif *= -1
    if (!sub_move.ydir) y_dif *= -1
    playerCharacterCoords.update((coords) => {
      coords[characterId].x += x_dif / SCALING_FACTOR
      coords[characterId].y += y_dif / SCALING_FACTOR
      return coords
    })
  }

  frameCounter.update((fc) => fc + 1)
}
