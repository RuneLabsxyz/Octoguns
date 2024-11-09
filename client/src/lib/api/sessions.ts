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

async function Global() {
  const { torii, clientComponents } = await getDojo()
  const valueHash = torii.poseidonHash(['0']) // global uses 0 as id

  return componentValueStore(clientComponents.Global, valueHash)
}

export async function Session(
  sessionId: number
): Promise<Readable<Session | null>> {
  // We consider they are unchangeable
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(sessionId)])
  // return a component value store of the object:
  return derived(
    [componentValueStore(clientComponents.Session, valueHash)],
    ([val], set) => {
      let result: Session = {
        ...val,
      }
      set(result)
    }
  )
}

export const yourSessions: Readable<Session[]> = derived(
  [currentPlayer],
  ([player], set) => {
    if (player == null) {
      set([])
      return
    }

    Promise.all(
      player.games.map(async (session_id) => {
        const session = await Session(Number(session_id))
        return new Promise<Session>((resolve) => {
          session.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessions) => {
      set(sessions)
    })
  }
)

export const yourActiveSessions = derived([yourSessions], ([sessions], set) => {
  set(sessions.filter((session) => session.state === 1 || session.state === 2))
})

export const yourUnstartedSessions = derived(
  [yourSessions],
  ([sessions], set) => {
    set(sessions.filter((session) => session.state === 0))
  }
)

export const yourFinishedSessions = derived(
  [yourSessions],
  ([sessions], set) => {
    set(sessions.filter((session) => session.state === 3))
  }
)
