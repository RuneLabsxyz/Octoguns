import { frameCounter, recordedMove, mapObjects } from '$stores/gameStores'
import { get } from 'svelte/store'
import type { TurnData } from '$stores/gameStores'
import { PerspectiveCamera } from 'three'
import * as THREE from 'three'
import {
  type BulletCoords,
  bulletRender,
  bulletStart,
  bulletInitialPosition,
  bulletRenderOnchain,
  bulletInitialPositionOnchain
} from '$stores/coordsStores'
import { playSoundEffect } from './audioUtils'
import { splat } from '$stores/eyeCandy'
import { isTurnPlayer } from '$stores/gameStores'
import { truncate, getYawAngle, inverseMapAngle } from '$lib/helper'
import { BULLET_SPEED } from '$lib/consts'

function applyBulletToStore(newBullet: BulletCoords) {
  bulletRender.update((bullets) => {
    bullets.push(newBullet)
    return bullets
  })

  // Also store the initial position
  bulletInitialPosition.update((bullets) => {
    bullets.push(newBullet)
    return bullets
  })

  playSoundEffect('/audio/sfx/shot.wav')
}

export function shoot(camera: PerspectiveCamera) {
  let move_index = Math.floor(get(frameCounter) / 3)

  let direction = getYawAngle(camera)
  if (direction < 0) {
    direction = 360 + direction
  }

  direction = Math.round(truncate(direction, 8) * 10 ** 8)

  console.log(
    `Bullet shot at move index ${move_index} with angle ${direction} degrees`
  )

  recordedMove.update((rm) => {
    rm.shots.push({ angle: direction, step: move_index })
    console.log(rm.shots)
    return rm
  })

  let vx = Math.cos(THREE.MathUtils.degToRad(direction / 10 ** 8))
  let vy = Math.sin(THREE.MathUtils.degToRad(direction / 10 ** 8))

  const cameraPosition = camera.position
  const newBullet = {
    coords: {
      x: cameraPosition.x,
      y: cameraPosition.z,
    },
    shot_at: {
      x: cameraPosition.x,
      y: cameraPosition.z,
    },
    velocity: { x: vx, y: vy },

    shot_by: get(isTurnPlayer) ? 1 : 2,
    id: 0,
  }

  applyBulletToStore(newBullet)
}

export function replayShot(move: TurnData, camera: PerspectiveCamera) {
  let move_index = Math.floor((get(frameCounter) + 1) / 3)

  let shot = move.shots.find((shot) => shot.step === move_index)
  if (shot) {
    let angle = shot.angle

    console.log(`Bullet shot at move index ${move_index} with angle ${angle}`)

    let vx = Math.cos(THREE.MathUtils.degToRad(angle / 10 ** 8))
    let vy = Math.sin(THREE.MathUtils.degToRad(angle / 10 ** 8))

    frameCounter.update((fc) => fc + 1)

    const cameraPosition = camera.position
    const newBullet = {
      coords: {
        x: cameraPosition.x,
        y: cameraPosition.z,
      },
      shot_at: {
        x: cameraPosition.x,
        y: cameraPosition.z,
      },
      velocity: { x: vx, y: vy },
      id: 0,
      //TODO: Fix this
      shot_by: get(isTurnPlayer) ? 1 : 2,
    }

    applyBulletToStore(newBullet)
  }
}

export function resetBullets() {
  // Set bulletRender back to the original state from onchain store
  bulletRender.set(get(bulletRenderOnchain))

  // Set bulletInitialPosition back to the original state from onchain store
  bulletInitialPosition.set(get(bulletInitialPositionOnchain))
}

export function simulate() {
  // Extract wall coordinates from mapObjects
  const wallCoords = get(mapObjects).objects.map((index) => {
    //@ts-ignore
    let i = index.value
    let x = (i % 25) * 4 + 2 - 50
    let y = Math.floor(i / 25) * 4 + 2 - 50
    return { x, y }
  })

  // Define the boundaries of the map
  const mapBoundary = {
    minX: -50,
    maxX: 50,
    minY: -50,
    maxY: 50,
  }

  // Update temp / new bullets
  bulletRender.update((bullets) => {
    let newBullets: BulletCoords[] = []
    bullets.map((bullet) => {
      const newX = bullet.coords.x + bullet.velocity.x * BULLET_SPEED
      const newY = bullet.coords.y + bullet.velocity.y * BULLET_SPEED



      // Check if the bullet is outside the map boundaries
      const isOutsideMap =
        newX < mapBoundary.minX ||
        newX > mapBoundary.maxX ||
        newY < mapBoundary.minY ||
        newY > mapBoundary.maxY

      if (!isOutsideMap) {
        newBullets.push({
          ...bullet,
          coords: {
            x: newX,
            y: newY,
          },
        })
      }
      if (isOutsideMap) {
        splat.update((splat) => {
          splat.push({ x: newX, y: newY })
          return splat
        })
      }
    })
    return newBullets
  })
}
