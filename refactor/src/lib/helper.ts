import { Vector3, Quaternion, Euler, PerspectiveCamera } from "three";
import * as THREE from "three";
import { SCALING_FACTOR, SUBMOVE_SCALE } from "$lib/consts";

export function areAddressesEqual(address1: string, address2: string): boolean {
  const bigIntAddress1 = BigInt(address1)
  const bigIntAddress2 = BigInt(address2)
  return bigIntAddress1 === bigIntAddress2
}


export function truncate(value: number, factor: number): number {
  return Math.trunc(value * 10 ** factor) / 10 ** factor;
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
  const length = Math.sqrt(x * x + y * y);

  if (length === 0) {
    return { x: 0, y: 0 };
  }

  // Calculate the scaled components without flooring
  let scaledX = Math.trunc((x / length) * SCALE_FACTOR);
  let scaledY = Math.trunc((y / length) * SCALE_FACTOR);

  return {
    x: scaledX,
    y: scaledY,
  };
}

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
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
  degrees = ((90 - degrees) % 360 + 360) % 360
  
  return degrees
}