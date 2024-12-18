import { accountStore, getDojo, getDojoContext } from '$src/stores/dojoStore'
import { derived, readable, type Readable } from 'svelte/store'
import { SessionStore } from './sessions'
import { SessionMeta } from './sessionMeta'
import get from './utils'
import { getMap } from './maps'
import { areAddressesEqual } from '$lib/helper'
import { BulletsStore } from './data/bullets'
import { CharactersStore } from './data/characters'
import type { Map } from '$src/dojo/models.gen'
import type { Position } from './gameState'


export type GameStore = Awaited<ReturnType<typeof Game>>

export async function Game(sessionId: number) {

  let sessionStore = await SessionStore(sessionId)
  let sessionMetaStore = await SessionMeta(sessionId)

  let bulletStore = BulletsStore(sessionMetaStore)

  let mapStore: Readable<Map | null> = derived(
    [sessionStore],
    ([session], set) => {
      if (session == null) {
        set(null)
        return
      }
      return get(getMap(Number(session.map_id))).subscribe(set)
    }
  )

  let charactersStore = CharactersStore(sessionMetaStore)

  let turnCountStore: Readable<number | null> = derived(
    [sessionMetaStore],
    ([sessionMeta]) => {
      if (sessionMeta == null) {
        return null
      }
      return Number(sessionMeta?.turn_count)
    }
  )

  let currentPlayerIdStore = derived([sessionStore, accountStore], ([session, account]) => {
    const player_address = account?.address

    if (session == null) {
      return null
    }

    let isFirstPlayer = areAddressesEqual(
      session.player1.toString(),
      player_address ?? ''
    )

    let isSecondPlayer = areAddressesEqual(
      session.player2.toString(),
      player_address ?? ''
    )

    if (isFirstPlayer) {
      return 1
    } else if (isSecondPlayer) {
      return 2
    } else {
      return null
    }
  })

  let currentPlayerCharacterIdStore = derived(
    [currentPlayerIdStore, sessionMetaStore],
    ([playerId, sessionMeta]) => {
      if (playerId == null) {
        return null
      }

      return [
        Number(sessionMeta?.p1_character),
        Number(sessionMeta?.p2_character),
      ][playerId]
    }
  )

  let isCurrentPlayersTurnStore = derived(
    [sessionMetaStore, currentPlayerIdStore],
    ([sessionMeta, currentPlayer]) => {
      if (sessionMeta == null || currentPlayer == null) {
        return null
      }
      switch (currentPlayer) {
        case 1:
          return Number(sessionMeta.turn_count) % 2 === 0
        case 2:
          return Number(sessionMeta.turn_count) % 2 === 1
        default:
          return null
      }
    }
  )

  return {
    sessionId: readable(sessionId),
    session: sessionStore,
    sessionMeta: sessionMetaStore,
    map: mapStore,
    turnCount: turnCountStore,
    currentPlayerId: currentPlayerIdStore,
    currentPlayerCharacterId: currentPlayerCharacterIdStore,
    isCurrentPlayersTurn: isCurrentPlayersTurnStore,
    bullets: bulletStore,
    characters: charactersStore,
  }
}
