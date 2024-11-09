import { componentValueStore } from '$src/dojo/componentValueStore'
import type {
  SessionMeta,
  Global,
  Bullet,
  CharacterModel,
  CharacterPosition,
} from '$src/dojo/models.gen'
import { getDojo, accountStore, getDojoContext } from '$src/stores/dojoStore'
import {
  derived,
  readable,
  writable,
  type Readable,
  type Writable,
} from 'svelte/store'
import { account } from '$src/stores/account'
import { currentPlayer } from './player'
import { currentGlobal } from './global'
import { poseidonHash } from '@dojoengine/torii-wasm'
import { sessionMeta } from '$src/lib/api/sessionMeta'
import { Session } from '$src/lib/api/sessions'
import { get } from 'svelte/store'

export async function bullet(
  bullet_id: number
): Promise<Readable<Bullet | null>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(bullet_id)])

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

export async function bullets(
  session_id: number
): Promise<Readable<Bullet[] | null>> {
  const SessionMeta = await sessionMeta(Number(session_id))

  return derived(SessionMeta, ($SessionMeta, set) => {
    if (!$SessionMeta?.bullets) {
      set(null)
      return
    }

    // Create an array of bullet stores
    const bulletStores = $SessionMeta.bullets.map(async (bulletId) => {
      return await bullet(Number(bulletId))
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

export async function characterModel(
  entity_id: number
): Promise<Readable<CharacterModel>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(entity_id)])

  return derived(
    [componentValueStore(clientComponents.CharacterModel, valueHash)],
    ([val], set) => {
      let result: CharacterModel = {
        ...val,
      }

      set(result)
    }
  )
}

export async function characterPosition(
  entity_id: number
): Promise<Readable<CharacterPosition>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(entity_id)])

  return derived(
    [componentValueStore(clientComponents.CharacterPosition, valueHash)],
    ([val], set) => {
      let result: CharacterPosition = {
        ...val,
      }

      set(result)
    }
  )
}

export async function gameCharacterModel(
  session_id: number
): Promise<Readable<[CharacterModel | null, CharacterModel | null]>> {
  const SessionMeta = await sessionMeta(Number(session_id))
  const session = await Session(Number(session_id))
  const { torii, clientComponents } = await getDojo()

  // Get the current player's address
  const currentPlayerAddress = get(currentPlayer)?.player

  return derived(SessionMeta, ($SessionMeta, set) => {
    if (!$SessionMeta) {
      set([null, null])
      return
    }

    const sessionValue = get(session)

    if (sessionValue == null) {
      set([null, null])
      return
    }

    // Determine the character entity IDs for the current player and the enemy
    let yourCharacterEntityId: number | null = null
    let enemyCharacterEntityId: number | null = null

    if (sessionValue.player1 === currentPlayerAddress) {
      yourCharacterEntityId = Number($SessionMeta.p1_character)
      enemyCharacterEntityId = Number($SessionMeta.p2_character)
    } else if (sessionValue.player2 === currentPlayerAddress) {
      yourCharacterEntityId = Number($SessionMeta.p2_character)
      enemyCharacterEntityId = Number($SessionMeta.p1_character)
    }

    if (yourCharacterEntityId === null || enemyCharacterEntityId === null) {
      set([null, null])
      return
    }

    async function fetchCharacterModels() {
      // Get the CharacterModels for both your character and the enemy
      const yourCharacterModelStore = await characterModel(
        Number(yourCharacterEntityId)
      )
      const enemyCharacterModelStore = await characterModel(
        Number(enemyCharacterEntityId)
      )

      set([get(yourCharacterModelStore), get(enemyCharacterModelStore)])
    }

    fetchCharacterModels()
  })
}

export async function gameCharacterPosition(
  session_id: number
): Promise<Readable<[CharacterPosition | null, CharacterPosition | null]>> {
  const SessionMeta = await sessionMeta(Number(session_id))
  const session = await Session(Number(session_id))
  const { torii, clientComponents } = await getDojo()

  // Get the current player's address
  const currentPlayerAddress = get(currentPlayer)?.player

  return derived(SessionMeta, ($SessionMeta, set) => {
    if (!$SessionMeta) {
      set([null, null])
      return
    }

    const sessionValue = get(session)

    if (sessionValue == null) {
      set([null, null])
      return
    }

    // Determine the character entity IDs for the current player and the enemy
    let yourCharacterEntityId: number | null = null
    let enemyCharacterEntityId: number | null = null

    if (sessionValue.player1 === currentPlayerAddress) {
      yourCharacterEntityId = Number($SessionMeta.p1_character)
      enemyCharacterEntityId = Number($SessionMeta.p2_character)
    } else if (sessionValue.player2 === currentPlayerAddress) {
      yourCharacterEntityId = Number($SessionMeta.p2_character)
      enemyCharacterEntityId = Number($SessionMeta.p1_character)
    }

    if (yourCharacterEntityId === null || enemyCharacterEntityId === null) {
      set([null, null])
      return
    }

    async function fetchCharacterModels() {
      // Get the CharacterModels for both your character and the enemy
      const yourCharacterModelStore = await characterPosition(
        Number(yourCharacterEntityId)
      )
      const enemyCharacterModelStore = await characterPosition(
        Number(enemyCharacterEntityId)
      )

      set([get(yourCharacterModelStore), get(enemyCharacterModelStore)])
    }

    fetchCharacterModels()
  })
}
