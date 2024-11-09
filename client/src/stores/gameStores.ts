import { writable, get } from 'svelte/store'
import { type Bullet } from '$src/dojo/models.gen'
import { WebGLRenderer } from 'three'

export const rendererStore = writable<WebGLRenderer>()

// Game meta data
export const gameState = writable<number>()
export const sessionId = writable<number>()
export const isEnded = writable<boolean>(false)
export const currentPlayerId = writable<number | null>(null)
export const turnCount = writable<number>(0)

//characters
export const characterIds = writable<number[]>([])
export const playerCharacterId = writable<number>(0)
export const enemyCharacterId = writable<number>(1)
//true for recording, false for replaying
export const recordingMode = writable<boolean>(false)
export const replayMode = writable<boolean>(false)

// Holds informations about if you are the second player or not
export const isSecondPlayer = writable<boolean>(false)

export const recordedMove = writable<TurnData>({
  sub_moves: [],
  shots: [],
})

export const currentSubMove = writable<{ x: number; y: number }>({ x: 0, y: 0 })

export const frameCounter = writable<number>(0)
export const isMoveRecorded = writable<boolean>(false)

export type MapObjects = {
  grid1: bigint
  grid2: bigint
  grid3: bigint
}

export const mapObjects = writable<MapObjects>()

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
