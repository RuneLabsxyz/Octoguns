import { componentValueStore } from '$src/dojo/componentValueStore'
import type { SessionMeta, Global } from '$src/dojo/models.gen'
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
import { poseidonHash } from '@dojoengine/torii-wasm'
import {
  openSessions,
  yourSessions,
  yourActiveSessions,
  yourFinishedSessions,
  yourUnstartedSessions,
} from './sessions'

export async function sessionMeta(
  session_id: number
): Promise<Readable<SessionMeta | null>> {
  const { torii, clientComponents } = await getDojo()

  const valueHash = torii.poseidonHash([String(session_id)])

  return derived(
    [componentValueStore(clientComponents.SessionMeta, valueHash)],
    ([val], set) => {
      let result: SessionMeta = {
        ...val,
      }
      set(result)
    }
  )
}

export const openSessionMetas: Readable<SessionMeta[]> = derived(
  [openSessions],
  ([sessions], set) => {
    if (sessions.length == 0) {
      set([])
      return
    }
    Promise.all(
      sessions.map(async (session) => {
        const sessionMetaValue = await sessionMeta(Number(session.session_id))
        return new Promise<SessionMeta>((resolve) => {
          sessionMetaValue.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessionMetas) => {
      set(sessionMetas)
    })
  }
)

export const yourSessionMetas: Readable<SessionMeta[]> = derived(
  [yourSessions],
  ([sessions], set) => {
    if (sessions.length == 0) {
      set([])
      return
    }
    Promise.all(
      sessions.map(async (session) => {
        const sessionMetaValue = await sessionMeta(Number(session.session_id))
        return new Promise<SessionMeta>((resolve) => {
          sessionMetaValue.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessionMetas) => {
      set(sessionMetas)
    })
  }
)

export const yourActiveSessionMetas: Readable<SessionMeta[]> = derived(
  [yourActiveSessions],
  ([sessions], set) => {
    if (sessions.length == 0) {
      set([])
      return
    }
    Promise.all(
      sessions.map(async (session) => {
        const sessionMetaValue = await sessionMeta(Number(session.session_id))
        return new Promise<SessionMeta>((resolve) => {
          sessionMetaValue.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessionMetas) => {
      set(sessionMetas)
    })
  }
)

export const yourFinishedSessionsMetas: Readable<SessionMeta[]> = derived(
  [yourFinishedSessions],
  ([sessions], set) => {
    if (sessions.length == 0) {
      set([])
      return
    }
    Promise.all(
      sessions.map(async (session) => {
        const sessionMetaValue = await sessionMeta(Number(session.session_id))
        return new Promise<SessionMeta>((resolve) => {
          sessionMetaValue.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessionMetas) => {
      set(sessionMetas)
    })
  }
)

export const yourUnstartedSessionsMetas: Readable<SessionMeta[]> = derived(
  [yourUnstartedSessions],
  ([sessions], set) => {
    if (sessions.length == 0) {
      set([])
      return
    }
    Promise.all(
      sessions.map(async (session) => {
        const sessionMetaValue = await sessionMeta(Number(session.session_id))
        return new Promise<SessionMeta>((resolve) => {
          sessionMetaValue.subscribe((value) => {
            if (value) {
              resolve(value)
            }
          })
        })
      })
    ).then((sessionMetas) => {
      set(sessionMetas)
    })
  }
)
