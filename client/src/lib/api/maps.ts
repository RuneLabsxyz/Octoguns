import { currentGlobal } from './global'
import { derived, type Readable } from 'svelte/store'
import type { Map } from '$src/dojo/models.gen'
import { getDojo } from '$src/stores/dojoStore'
import { componentValueStore } from '$src/dojo/componentValueStore'
import { currentSession, currentSessionId } from './sessions'

export async function getMap(map_id: number): Promise<Readable<Map | null>> {
  // We consider they are unchangeable
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(map_id)])
  // return a component value store of the object:
  return derived(
    [componentValueStore(clientComponents.Map, valueHash)],
    ([val], set) => {
      let result: Map = {
        ...val,
      }
      set(result)
    }
  )
}

export const currentMap = derived([currentSession], ([session], set) => {
  if (session == null) {
    set(null)
    return
  }

  let unsubscribe = () => {}

  getMap(Number(session.map_id)).then(
    (val) => (unsubscribe = val.subscribe(set))
  )

  return () => unsubscribe()
})

export const maps: Readable<Map[] | null> = derived(
  currentGlobal,
  ($currentGlobal, set) => {
    console.log('getting maps')
    if (!$currentGlobal?.map_count) {
      set(null)
      return
    }
    const mapPromises: Promise<any>[] = []
    for (let i = 0; i < Number($currentGlobal.map_count); i++) {
      mapPromises.push(getMap(i))
    }

    async function fetchMapStores() {
      const mapStores = await Promise.all(mapPromises)
      const mapsArray: Map[] = []

      mapStores.forEach((mapStore) => {
        mapStore.subscribe((map: Map) => {
          if (map) {
            mapsArray.push(map)
            set(mapsArray)
          }
        })
      })
    }

    fetchMapStores()
  }
)
