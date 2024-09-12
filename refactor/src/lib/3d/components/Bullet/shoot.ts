import { frameCounter, recordedMove } from '$stores/gameStores'
import { get } from 'svelte/store'
import type { TurnData } from '$stores/gameStores'
import { PerspectiveCamera } from 'three'
import * as THREE from 'three'

export function shoot(camera: PerspectiveCamera) {
  let move_index = Math.floor(get(frameCounter) / 3)

  let direction =
    Math.atan2(
      camera.getWorldDirection(new THREE.Vector3()).x,
      camera.getWorldDirection(new THREE.Vector3()).z
    ) *
    (180 / Math.PI)

  direction = Math.round((direction + 360) % 360)

  recordedMove.update((rm) => {
    rm.shots.push({ index: move_index, angle: direction })
    return rm
  })
}
export function replayShot(move: TurnData) {
  let move_index = Math.floor((get(frameCounter) + 1) / 3)

  let shot = move.shots.find((shot) => shot.index === move_index)
  if (shot) {
    console.log(
      `Bullet shot at move index ${move_index} with angle ${shot.angle}`
    )
  }

  frameCounter.update((fc) => fc + 1)
}
