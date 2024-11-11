// Add this new function
export function isOutsideMapBoundary(x: number, y: number): boolean {
  const mapBoundary = {
    minX: -50,
    maxX: 50,
    minY: -50,
    maxY: 50,
  }

  return (
    x < mapBoundary.minX ||
    x > mapBoundary.maxX ||
    y < mapBoundary.minY ||
    y > mapBoundary.maxY
  )
}
