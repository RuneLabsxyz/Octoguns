import { writable, get } from 'svelte/store'
import { type Bullet } from '$src/dojo/models.gen'
import { WebGLRenderer } from 'three'

export const rendererStore = writable<WebGLRenderer>()

// Game meta data
export const gameState = writable<number>()
export const sessionId = writable<number>()

//characters
export const characterIds = writable<number[]>([])
export const playerCharacterId = writable<number>(0)
export const enemyCharacterId = writable<number>(1)
//true for recording, false for replaying
export const recordingMode = writable<boolean>(false)
export const replayMode = writable<boolean>(false)

export const recordedMove = writable<TurnData>({
  sub_moves: [],
  shots: [],
})

export const currentSubMove = writable<{ x: number; y: number }>({ x: 0, y: 0 })

export const frameCounter = writable<number>(0)
export const isMoveRecorded = writable<boolean>(false)
export const playerStartCoords = writable<CoordsStore>({})

export type TurnData = {
  sub_moves: { x: number; y: number; xdir: boolean; ydir: boolean }[]
  shots: { angle: number; step: number }[]
}

//store for bullets that are shot in current move but not yet onchain, so they don't have an id
export const tempBullets = writable<BulletCoords[]>([])
export const bulletStartCoords = writable<BulletCoordsStore>({})
export const bulletRenderCoords = writable<BulletCoordsStore>({})

export const keyStateStore = writable<{
  w: boolean
  a: boolean
  s: boolean
  d: boolean
  forward: boolean
  backward: boolean
  left: boolean
  right: boolean
}>({
  w: false,
  a: false,
  s: false,
  d: false,
  forward: false,
  backward: false,
  left: false,
  right: false,
})

export const isMouseDownStore = writable<boolean>(false)

export const isTurnPlayer = writable<boolean>(false)

export interface Coords {
  x: number
  y: number
}

export interface BulletCoords {
  coords: Coords
  id: number
  angle: number
  shot_by: number
}

export type CoordsStore = Record<number, Coords>
export type BulletCoordsStore = Record<number, BulletCoords>

export const playerCharacterCoords = writable<CoordsStore>({})
export const enemyCharacterCoords = writable<CoordsStore>({})

function normalizeCoords(coords: Coords): Coords {
  return {
    x: coords.x / 1000 - 50,
    y: coords.y / 1000 - 50,
  }
}

export function setPlayerCharacterCoords(
  key: number,
  coords: { x: number; y: number }
): void {
  if (coords.x > 100) {
    coords = normalizeCoords(coords)
  }
  playerCharacterCoords.update((store) => {
    return {
      ...store,
      [key]: coords,
    }
  })
}

export function setBulletCoords(
  key: number,
  data: { coords: { x: number; y: number }, id: number, angle: number, shot_by: number }
): void {
  let coords = data.coords
  console.log(coords)
  if (data.coords.x > 100) {
    data.coords = normalizeCoords(data.coords)
  }
  bulletRenderCoords.update((store) => {
    console.log(data)
    return {
      ...store,
      [key]: data,
    }
  })
}

export function setEnemyCharacterCoords(
  key: number,
  coords: { x: number; y: number }
): void {
  if (coords.x > 100) {
    coords = normalizeCoords(coords)
  }
  enemyCharacterCoords.update((store) => {
    return {
      ...store,
      [key]: coords,
    }
  })
}
