import { frameCounter, recordedMove, bulletRenderCoords, bulletStartCoords, tempBullets, type BulletCoordsStore } from '$stores/gameStores'
import { get } from 'svelte/store'
import type { TurnData } from '$stores/gameStores'
import { PerspectiveCamera } from 'three'
import * as THREE from 'three'
import type { Coords, BulletCoords} from '$stores/gameStores'
import { isTurnPlayer } from '$stores/gameStores'
import { truncate, adjustAngle } from '$lib/helper'

function applyTempBulletToStore(newBullet: BulletCoords) {
  tempBullets.update((bullets) => {
    bullets.push(newBullet)
    return bullets
  })
}

export function shoot(camera: PerspectiveCamera) {
  let move_index = Math.floor(get(frameCounter) / 3)

  let direction = adjustAngle(THREE.MathUtils.radToDeg(camera.rotation.z)) ;

  direction = Math.round(truncate(direction, 8) * 10**8);

  console.log(`Bullet shot at move index ${move_index} with angle ${direction} degrees`)

  recordedMove.update((rm) => {
    rm.shots.push({ angle: direction, step: move_index })
    console.log(rm.shots)
    return rm
  })

  const cameraPosition = camera.position
  const newBullet = {
    coords: {
      x: cameraPosition.x,
      y: cameraPosition.z,
    },
    angle: direction / 10**8,
    shot_by: get(isTurnPlayer) ? 1 : 2,
    id: 0
  }

  applyTempBulletToStore(newBullet)
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
      coords: {
        x: cameraPosition.x,
        y: cameraPosition.z,
      },
      angle: shot.angle,
      id: 0,
      //TODO: Fix this
      shot_by: get(isTurnPlayer) ? 1 : 2
    }

    applyTempBulletToStore(newBullet)
  }
}

export function clearBullets() {
  tempBullets.set([])
}

export function simulate() {
  const speed = 0.05

  //update temp / new bullets
  tempBullets.update((bullets) => {
    let newBullets: BulletCoords[] = []
    bullets.map((bullet) => {
      const angleInRadians = (((bullet.angle - 90) % 360) * Math.PI) / 180
      const newX = bullet.coords.x + speed * Math.cos(angleInRadians / 10**8)
      const newY = bullet.coords.y - speed * Math.sin(angleInRadians / 10**8)
      newBullets.push( {
        ...bullet,
        coords: {
          x: newX,
          y: newY,
        },
      })
    })
    return newBullets
  })

  //update rendered / already existing bullets
  bulletRenderCoords.update((bullets) => {
    let newBullets: BulletCoordsStore = {}
    Object.entries(bullets).forEach(([key, bullet]) => {
      const angleInRadians = ((((bullet.angle / 10 ** 8) - 90) % 360) * Math.PI) / 180
      const newX = bullet.coords.x + speed * Math.cos(angleInRadians)
      const newY = bullet.coords.y - speed * Math.sin(angleInRadians)
      newBullets[bullet.id] = {
        ...bullet,
        coords: {
          x: newX,
          y: newY,
        },
      }
    })

    return newBullets
    })

}
