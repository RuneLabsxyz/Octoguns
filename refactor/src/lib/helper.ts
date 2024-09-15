import { Vector3, Quaternion } from "three";
import { SCALING_FACTOR, SUBMOVE_SCALE } from "$lib/consts";

export function areAddressesEqual(address1: string, address2: string): boolean {
  const bigIntAddress1 = BigInt(address1)
  const bigIntAddress2 = BigInt(address2)
  return bigIntAddress1 === bigIntAddress2
}

export function truncateToDecimals(num: number, decimalPlaces: number) {
  const multiplier = Math.pow(10, decimalPlaces)
  return Math.floor(num * multiplier) / multiplier
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

  const normalizedX = Math.floor((x / length) * SCALE_FACTOR);
  const normalizedY = Math.floor((y / length) * SCALE_FACTOR);

  return { x: normalizedX, y: normalizedY };
}

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}