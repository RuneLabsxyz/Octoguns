import { Vector3 } from 'three';
import {
  keyStateStore,
  isMouseDownStore,
  recordedMove,
  currentSubMove,
  frameCounter,
  playerCharacterCoords,
  recordingMode,
  isMoveRecorded,
  replayMode,
<<<<<<< HEAD
  playerStartCoords,
} from '$stores/gameStores';
import type { TurnData } from '$stores/gameStores';
import { get } from 'svelte/store';
import { T } from "@threlte/core"
import { Camera } from 'three';
import { SCALING_FACTOR, FRAME_INTERVAL, RECORDING_FRAME_LIMIT, SUBMOVE_SCALE } from '$lib/consts';
import { normalizeAndScaleVector,clamp } from '$lib/helper';


export function recordMove(camera: Camera, characterId: number) {
  const moveDirection = new Vector3();
  const {
    forward,
    backward,
    left,
    right,
  } = get(keyStateStore);
  const isMouseDown = get(isMouseDownStore);

  if (forward) moveDirection.z -= 1;
  if (backward) moveDirection.z += 1;
  if (left) moveDirection.x -= 1;
  if (right) moveDirection.x += 1;
  let shoot: boolean = false;
  if (isMouseDown) shoot = true;
=======
} from '$stores/gameStores'
import { truncateToDecimals } from '$lib/helper.'
import type { TurnData } from '$stores/gameStores'
import { get } from 'svelte/store'
import type * as THREE from 'three'
import { clearBullets } from '../components/Bullet/shoot'

const move_speed = 0.333
const moveDirection = new Vector3()

export function recordMove(camera: THREE.Camera, characterId: number) {
  if (get(keyStateStore).forward) moveDirection.z -= 1
  if (get(keyStateStore).backward) moveDirection.z += 1
  if (get(keyStateStore).left) moveDirection.x -= 1
  if (get(keyStateStore).right) moveDirection.x += 1
  let shoot: boolean = false
  if (get(isMouseDownStore)) shoot = true
>>>>>>> c53de539abe4dabdd099a8c0cc776c5ddd8dbee4

  if (moveDirection.length() > 0) {
    // Scale move direction and convert to integers using Math.round

    if (camera.quaternion) {
      moveDirection.applyQuaternion(camera.quaternion);
    } else {
      console.warn('Camera quaternion is undefined.');
    }

    // Normalize and scale the move direction to maintain consistent speed
    const normalized = normalizeAndScaleVector(moveDirection.x, moveDirection.z, SUBMOVE_SCALE / 3);
    moveDirection.x = normalized.x;
    moveDirection.z = normalized.y;

    // Ensure y-axis movement is zero (assuming 2D movement)
    moveDirection.y = 0;

    // Update player coordinates with clamped values to stay within grid bounds
    playerCharacterCoords.update((coords) => {
<<<<<<< HEAD
      coords[characterId].x = clamp(coords[characterId].x + (moveDirection.x / SCALING_FACTOR), -50, 50);
      coords[characterId].y = clamp(coords[characterId].y + (moveDirection.z / SCALING_FACTOR), -50, 50);
      return coords;
    });
=======
      coords[characterId].x += moveDirection.x / 10
      coords[characterId].y += moveDirection.z / 10
      return coords
    })
>>>>>>> c53de539abe4dabdd099a8c0cc776c5ddd8dbee4

    currentSubMove.update((subMove) => {
      subMove.x += moveDirection.x;
      subMove.y += moveDirection.z;
      return subMove;
    });

    if (get(frameCounter) % FRAME_INTERVAL === 0) {
      const current = normalizeAndScaleVector(get(currentSubMove).x, get(currentSubMove).y, SUBMOVE_SCALE);      
      
      console.log(Math.sqrt(current.x * current.x + current.y * current.y));

      let move = {
        x: Math.abs(current.x),
        y: Math.abs(current.y),
        xdir: current.x >= 0,
        ydir: current.y >= 0,
      };
      recordedMove.update((rm) => {
        rm.sub_moves.push(move);
        return rm;
      });
      currentSubMove.set({ x: 0, y: 0 });
    }

    // Increment frame counter
    frameCounter.update((fc) => fc + 1);
  }

<<<<<<< HEAD

  if (get(frameCounter) === RECORDING_FRAME_LIMIT) {
    recordingMode.set(false);
    isMoveRecorded.set(true);
    document.exitPointerLock();

    console.log(get(isMoveRecorded));
=======
  if (get(frameCounter) == 300) {
    recordingMode.set(false)
    isMoveRecorded.set(true)
    clearBullets()
    console.log(get(isMoveRecorded))
>>>>>>> c53de539abe4dabdd099a8c0cc776c5ddd8dbee4
  }

  // Reset move direction is not necessary since moveDirection is now scoped within the function
}

export function replayMove(move: TurnData, characterId: number) {
<<<<<<< HEAD
  let move_index = Math.floor(get(frameCounter) / FRAME_INTERVAL);
  if (move_index >= move.sub_moves.length) {
    console.warn('Move index exceeds recorded sub-moves.');
    return;
  }
  let sub_move = move.sub_moves[move_index];
  console.log(move);

  if (get(frameCounter) === RECORDING_FRAME_LIMIT) {
    frameCounter.set(0);
    replayMode.set(false);
    playerCharacterCoords.set(get(playerStartCoords));
=======
  let move_index = Math.floor(get(frameCounter) / 3)
  let sub_move = move.sub_moves[move_index]

  if (get(frameCounter) == 300) {
    replayMode.set(false)
    clearBullets()
>>>>>>> c53de539abe4dabdd099a8c0cc776c5ddd8dbee4
  }
  if (get(frameCounter) % FRAME_INTERVAL === 0 && get(frameCounter) < RECORDING_FRAME_LIMIT) {
    let x_dif = sub_move.x;
    let y_dif = sub_move.y;
    if (!sub_move.xdir) x_dif *= -1;
    if (!sub_move.ydir) y_dif *= -1;
    playerCharacterCoords.update((coords) => {
<<<<<<< HEAD
      coords[characterId].x += x_dif / SCALING_FACTOR;
      coords[characterId].y += y_dif / SCALING_FACTOR;
      return coords;
    });
=======
      coords[characterId].x += x_dif
      coords[characterId].y += y_dif
      return coords
    })
>>>>>>> c53de539abe4dabdd099a8c0cc776c5ddd8dbee4
  }

  frameCounter.update((fc) => fc + 1);
}
