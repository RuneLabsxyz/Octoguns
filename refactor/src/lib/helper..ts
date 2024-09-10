export function areAddressesEqual(address1: string, address2: string): boolean {
  const bigIntAddress1 = BigInt(address1)
  const bigIntAddress2 = BigInt(address2)
  return bigIntAddress1 === bigIntAddress2
}

export function truncateToDecimals(num: number, decimalPlaces: number) {
  const multiplier = Math.pow(10, decimalPlaces)
  return Math.floor(num * multiplier) / multiplier
}
