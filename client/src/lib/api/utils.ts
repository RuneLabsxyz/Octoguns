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
