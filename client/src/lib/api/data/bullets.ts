import { derived, get, type Readable } from 'svelte/store'
import type { Bullet, SessionMeta } from '$src/dojo/models.gen'
import { componentValueStore } from '$src/dojo/componentValueStore'
import { getDojo } from '$src/stores/dojoStore'

export async function BulletStore(
  bulletId: number
): Promise<Readable<Bullet | null>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(bulletId)])

  return derived(
    [componentValueStore(clientComponents.Bullet, valueHash)],
    ([val], set) => {
      let result: Bullet = {
        ...val,
      }
      set(result)
    }
  )
}

export function BulletsStore(
  sessionMetaStore: Readable<SessionMeta | null>
): Readable<Bullet[] | null> {
  return derived(sessionMetaStore, ($SessionMeta, set) => {
    if (!$SessionMeta?.bullets) {
      set(null)
      return
    }

    // Create an array of bullet stores
    const bulletStores = $SessionMeta.bullets.map(async (bulletId) => {
      return await BulletStore(Number((bulletId as any).value))
    })

    // Combine all bullet stores into a single array
    Promise.all(bulletStores).then((stores) => {
      const combinedStore = derived(stores, (bulletValues) =>
        bulletValues.filter((bullet) => bullet !== null)
      )
      set(get(combinedStore))
    })
  })
}
