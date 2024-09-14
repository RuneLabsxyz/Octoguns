import { frameCounter, recordedMove, bullets } from '$stores/gameStores'
import { get } from 'svelte/store'
import type { TurnData } from '$stores/gameStores'
import { PerspectiveCamera } from 'three'
import * as THREE from 'three'

function applyBulletToStore(newBullet: {
  x: number
  y: number
  angle: number
}) {
  bullets.update((bullets) => {
    bullets.push(newBullet)
    return bullets
  })
}

export function shoot(camera: PerspectiveCamera) {
  let move_index = Math.floor(get(frameCounter) / 3)

  let direction =
    Math.atan2(
      camera.getWorldDirection(new THREE.Vector3()).x,
      camera.getWorldDirection(new THREE.Vector3()).z
    ) *
    (180 / Math.PI)

  direction = Math.round((direction + 360) % 360)

  console.log(`Bullet shot at move index ${move_index} with angle ${direction}`)

  recordedMove.update((rm) => {
    rm.shots.push({ angle: direction * 10 ** 8, step: move_index })
    return rm
  })

  const cameraPosition = camera.position
  const newBullet = {
    x: cameraPosition.x,
    y: cameraPosition.z,
    angle: direction,
  }

  applyBulletToStore(newBullet)
}

export function replayShot(move: TurnData, camera: PerspectiveCamera) {
  let move_index = Math.floor((get(frameCounter) + 1) / 3)

  let shot = move.shots.find((shot) => shot.step === move_index)
  if (shot) {
    console.log(
      `Bullet shot at move index ${move_index} with angle ${shot.angle}`
    )

    frameCounter.update((fc) => fc + 1)

    const cameraPosition = camera.position
    const newBullet = {
      x: cameraPosition.x,
      y: cameraPosition.z,
      angle: shot.angle,
    }

    applyBulletToStore(newBullet)
  }
}

export function clearBullets() {
  bullets.set([])
}

export function simulate() {
  const currentBullets = get(bullets)
  const speed = 0.05

  const updatedBullets = currentBullets.map((bullet) => {
    const angleInRadians = (((bullet.angle - 90) % 360) * Math.PI) / 180
    const newX = bullet.x + speed * Math.cos(angleInRadians)
    const newY = bullet.y - speed * Math.sin(angleInRadians)

    return {
      ...bullet,
      x: newX,
      y: newY,
    }
  })

  bullets.set(updatedBullets)
}
