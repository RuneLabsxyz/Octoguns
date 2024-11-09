import {
  accountStore,
  dojoStore,
  getDojo,
  getDojoContext,
} from '$src/stores/dojoStore'
import type { TurnMove } from '$src/dojo/models.gen'
import { derived, writable, type Readable, type Writable } from 'svelte/store'
import { currentPlayer } from './player'
import { dojoConfig } from '$src/dojoConfig'
import { componentValueStore } from '$src/dojo/componentValueStore'
import get from './utils'

export async function move(session_id: number, moves: TurnMove) {
  // Get the context
  const [account, { client }] = await getDojoContext()
  try {
    await client.actions.move({
      account,
      session_id: session_id,
      moves: moves,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}
