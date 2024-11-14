export function load({ url }) {
  const segments = url.pathname.split('/').filter(Boolean)
  const gameId = segments[segments.length - 1] // Get the last segment
  return {
    gameId,
  }
}
