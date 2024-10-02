import { type SessionPrimitives } from '$dojo/models.gen'

export const MOVE_SPEED = 0.4
export const BULLET_SPEED = 0.2
export const BULLET_SUBSTEPS = 3
export const SCALING_FACTOR = 1000

export const TURN_COUNT = 100
export const FRAME_INTERVAL = 3
export const RECORDING_FRAME_LIMIT = TURN_COUNT * FRAME_INTERVAL

// Scaling factor to map 100x100 to 100,000x100,000 grid
export const SUBMOVE_SCALE = 400 // 0.4 * 1000

export const SESSION_PRIMITIVES: SessionPrimitives = {
  session_id: 0,
  bullet_speed: 300, // Assuming BULLET_SPEED * SCALING_FACTOR
  bullet_sub_steps: BULLET_SUBSTEPS,
  bullets_per_turn: 1, // Assuming 1 bullet per turn, adjust if needed
  sub_moves_per_turn: 100, // Assuming 1 sub-move per turn, adjust if needed
  max_distance_per_sub_move: 400,
}
