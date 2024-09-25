import { Vector3, Quaternion, Euler, PerspectiveCamera } from "three";
import * as THREE from "three";
import { SCALING_FACTOR, SUBMOVE_SCALE } from "$lib/consts";
import { type Bullet } from "../dojo/models.gen";


export function areAddressesEqual(address1: string, address2: string): boolean {
  const bigIntAddress1 = BigInt(address1)
  const bigIntAddress2 = BigInt(address2)
  return bigIntAddress1 === bigIntAddress2
}

export function truncate(value: number, factor: number): number {
  return Math.trunc(value * 10 ** factor) / 10 ** factor
}

/**
 * Normalizes a 2D vector and scales it to maintain integer precision.
 *
 * @param x - The x-component of the vector.
 * @param y - The y-component of the vector.
 * @param SCALE_FACTOR - The factor by which to scale the normalized vector.
 * @returns An object containing the normalized and scaled x and y components as integers.
 */
export function normalizeAndScaleVector(
  x: number,
  y: number,
  SCALE_FACTOR: number
): { x: number; y: number } {
  const length = Math.sqrt(x * x + y * y)

  if (length === 0) {
    return { x: 0, y: 0 }
  }

  // Calculate the scaled components without flooring
  let scaledX = Math.trunc((x / length) * SCALE_FACTOR)
  let scaledY = Math.trunc((y / length) * SCALE_FACTOR)

  return {
    x: scaledX,
    y: scaledY,
  }
}

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value))
}

/**
 * Calculates the yaw angle (rotation around Y-axis) in degrees.
 * @param camera - The PerspectiveCamera instance.
 * @returns The yaw angle in degrees.
 */
export function getYawAngle(camera: PerspectiveCamera): number {
  // Create a vector pointing in the positive Z direction
  const direction = new Vector3(0, 0, -1)

  // Apply the camera's rotation to the direction vector
  direction.applyQuaternion(camera.quaternion)

  // Project the direction vector onto the XZ plane (ignore Y)
  direction.y = 0
  direction.normalize()

  // Calculate the angle using atan2
  const radians = Math.atan2(direction.x, direction.z)

  // Convert to degrees
  let degrees = THREE.MathUtils.radToDeg(radians)

  // Normalize the angle between 0° and 360°
  degrees = (((90 - degrees) % 360) + 360) % 360

  return degrees
}

/**
 * Converts degrees from the traditional unit circle back to the original angular coordinate system.
 *
 * In the original system:
 * - Rotation is around the Y-axis.
 * - Clockwise rotation maps to [0, 180] degrees.
 * - Counterclockwise rotation maps to [0, -180] degrees.
 *
 * This function inverses the mapping:
 * originalDegrees = (180 - unitCircleDegrees) % 360 - 180
 *
 * @param angle - The angle in degrees from the traditional unit circle.
 * @returns The angle in degrees in the original coordinate system.
 */
export function inverseMapAngle(angle: number): number {
  // Normalize the input angle to [0, 360)
  const normalizedUnitCircleDegrees = ((angle % 360) + 360) % 360

  // Apply the corrected inverse mapping formula without the 90-degree offset
  let originalDegrees = ((180 - normalizedUnitCircleDegrees) % 360) - 180

  // Handle edge case where originalDegrees is -180, mapping it to 180 if desired
  if (originalDegrees === -180) {
    originalDegrees = 180
  }

  return originalDegrees
}

export function getBulletPosition(bullet: Bullet, step: number) {
  let vx = parseInt(bullet.velocity.x.toString()) / 1000
  let vy = parseInt(bullet.velocity.y.toString()) / 1000
  //@ts-ignore
  let x = parseInt(bullet.shot_at.x.toString()) / 1000
  //@ts-ignore
  let y = parseInt(bullet.shot_at.y.toString()) / 1000

  let x_dir = bullet.velocity.xdir ? 1 : -1
  let y_dir = bullet.velocity.ydir ? 1 : -1

  //@ts-ignore
  let shot_step = bullet.shot_step.value
  let new_x = x + (vx * (step - shot_step) * x_dir)
  let new_y = y + (vy * (step - shot_step) * y_dir)

  return {x: new_x - 50, y: new_y - 50}
}


