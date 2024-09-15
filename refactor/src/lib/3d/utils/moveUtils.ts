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
      coords[characterId].x = clamp(coords[characterId].x + (moveDirection.x / SCALING_FACTOR), -50, 50);
      coords[characterId].y = clamp(coords[characterId].y + (moveDirection.z / SCALING_FACTOR), -50, 50);
      return coords;
    });

    currentSubMove.update((subMove) => {
      subMove.x += moveDirection.x;
      subMove.y += moveDirection.z;
      console.log(subMove);
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


  if (get(frameCounter) === RECORDING_FRAME_LIMIT) {
    recordingMode.set(false);
    isMoveRecorded.set(true);
    document.exitPointerLock();

    console.log(get(isMoveRecorded));
  }

  // Reset move direction is not necessary since moveDirection is now scoped within the function
}

export function replayMove(move: TurnData, characterId: number) {
  let move_index = Math.floor(get(frameCounter) / FRAME_INTERVAL);
  if (move_index >= move.sub_moves.length) {
    console.warn('Move index exceeds recorded sub-moves.');
    return;
  }
  let sub_move = move.sub_moves[move_index];
  console.log(move);

  if (get(frameCounter) === RECORDING_FRAME_LIMIT) {
    replayMode.set(false);
  }
  if (get(frameCounter) % FRAME_INTERVAL === 0 && get(frameCounter) < RECORDING_FRAME_LIMIT) {
    let x_dif = sub_move.x;
    let y_dif = sub_move.y;
    if (!sub_move.xdir) x_dif *= -1;
    if (!sub_move.ydir) y_dif *= -1;
    playerCharacterCoords.update((coords) => {
      coords[characterId].x += x_dif;
      coords[characterId].y += y_dif;
      return coords;
    });
  }

  frameCounter.update((fc) => fc + 1);
}
