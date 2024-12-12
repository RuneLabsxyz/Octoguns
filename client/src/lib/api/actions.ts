import { getDojoContext } from '$src/stores/dojoStore'
import type { SessionPrimitives } from '$src/dojo/models.gen'
import type { TurnData } from './data/move'
export async function move(session_id: number, moves: TurnData) {
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

export async function createMap(grid1: bigint, grid2: bigint, grid3: bigint) {
  const [account, { client }] = await getDojoContext()
  try {
    await client.mapmaker.create({
      account,
      grid1: grid1,
      grid2: grid2,
      grid3: grid3,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}

export async function spawn(session_id: number) {
  const [account, { client }] = await getDojoContext()
  try {
    await client.spawn.spawn({
      account,
      session_id: session_id,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}

//TODO: UPDATE TO SETTINGS
export async function createGame(
  map_id: number,
  session_primitives: SessionPrimitives
) {
  const [account, { client }] = await getDojoContext()
  try {
    await client.start.create({
      account,
      map_id: map_id,
      session_primitives: session_primitives,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}

export async function createClosedGame(
  map_id: number,
  player_address_1: bigint,
  player_address_2: bigint,
  session_primitives: SessionPrimitives
) {
  const [account, { client }] = await getDojoContext()
  try {
    await client.start.create_closed({
      account,
      map_id: map_id,
      player_address_1: player_address_1,
      player_address_2: player_address_2,
      session_primitives: session_primitives,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}

export async function joinGame(session_id: number) {
  const [account, { client }] = await getDojoContext()
  try {
    await client.start.join({
      account,
      session_id: session_id,
    })
  } catch (err) {
    console.log('An error occurred while spawning: ', err)
  }
}
