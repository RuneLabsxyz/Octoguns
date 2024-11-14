export function load({ url }) {
  const firstSegment = url.pathname.split('/').filter(Boolean)[0]; // Extract the first path segment
  return {
      network: firstSegment,
  };
}
