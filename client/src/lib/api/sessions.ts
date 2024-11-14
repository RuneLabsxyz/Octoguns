import { componentValueStore } from '$src/dojo/componentValueStore'
import type { Session, Global } from '$src/dojo/models.gen'
import get from './utils'
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

export async function SessionStore(
  sessionId: number
): Promise<Readable<Session | null>> {
  // We consider they are unchangeable
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(sessionId)])
  // return a component value store of the object:
  return derived(
    [componentValueStore(clientComponents.Session, valueHash)],
    ([val], set) => {
      console.log('Managed to fetch a session', val)
      let result: Session = {
        ...val,
      }
      set(result)
    }
  )
}

export const currentSessionId = writable<number | undefined>()

export const currentSession: Readable<Session | null> = derived(
  [currentSessionId],
  ([currentSessionId], set) => {
    if (currentSessionId == undefined) {
      set(null)
      return
    }

    SessionStore(currentSessionId).then((val) => val.subscribe(set))
  }
)

/**
 * This allows players to see and join available game sessions.
 */

export const openSessions: Readable<Session[]> = derived(
  [currentPlayer, currentGlobal],
  ([player, global], set) => {
    if (global == null) {
      set([])
      return
    }
    console.log(' Getting opensessions:', global.pending_sessions)
    Promise.all(
      global.pending_sessions.map(async (session_id) => {
        const session = await SessionStore(Number((session_id as any).value))
        return new Promise<Session>((resolve) => {
          session.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessions) => {
      // Filter out sessions where player is player1 or player2 and state is not 0
      if (player == null) {
        set(sessions)
        return
      }
      const filteredSessions = sessions.filter(
        (session) =>
          session.player1 !== player.player &&
          session.player2 !== player.player &&
          session.state === 0
      )
      set(filteredSessions)
    })
  }
)

export const yourSessions: Readable<Session[]> = derived(
  [currentPlayer],
  ([player], set) => {
    if (player == null) {
      set([])
      return
    }
    console.log('Player:', player.games)

    Promise.all(
      player.games.map(async (session_id) => {
        const session = await SessionStore(Number((session_id as any).value))
        return new Promise<Session>((resolve) => {
          session.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessions) => {
      console.log("Got sessions", sessions)
      set(sessions)
    })
  }
)

export const yourActiveSessions: Readable<Session[]> = derived(
  [yourSessions],
  ([sessions]) => {
    if (sessions != null) {
      return sessions.filter((session) => session.state === 1 || session.state === 2)
    } else {
      return [];
    }
    
  }
)

export const yourUnstartedSessions: Readable<Session[]> = derived(
  [yourSessions],
  ([sessions]) => {
    if (sessions != null) {
      return sessions.filter((session) => session.state === 0)
    } else {
      return [];
    }
  }
)

export const yourFinishedSessions: Readable<Session[]> = derived(
  [yourSessions],
  ([sessions]) => {
    if (sessions != null) {
      return sessions.filter((session) => session.state === 3)
    } else {
      return [];
    }
  }
)
