import type { U256 } from '$src/dojo/models.gen'
import { readable, type Readable } from 'svelte/store'

export default function get<T>(
  asyncedStore: Promise<Readable<T | null>>
): Readable<T | null> {
  return readable<T | null>(null, (set) => {
    asyncedStore
      .then((store) => {
        store.subscribe((value) => {
          if (value !== undefined) {
            set(value)
          }
        })
      })
      .catch((err) => {
        console.error('An error occurred...', err)
      })
  })
}

export function getBigInt(val: U256) {
  if (val == null) {
    return null
  }
  return (
    BigInt(String(val))
  )
}
