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

  // Calculate the scaled components without flooring
  let scaledX = Math.floor((x / length) * SCALE_FACTOR);
  let scaledY = Math.floor((y / length) * SCALE_FACTOR);
  console.log(scaledX, scaledY);

  // Calculate the new length after scaling
  const newLength = Math.sqrt(scaledX * scaledX + scaledY * scaledY);
  if (newLength > 400) {
    if (scaledX > 0) {
      scaledX -=1;
    } 
    else {
      scaledX += 1;
    }
    if (scaledY > 0) {
      scaledY -=1;
    } 
    else {
      scaledY += 1;
    }
  } 

  return {
    x: Math.floor(scaledX),
    y: Math.floor(scaledY),
  };
}

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}