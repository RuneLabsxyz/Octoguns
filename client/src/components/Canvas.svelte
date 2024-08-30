<script lang="ts">
  import { T, useThrelte, useFrame } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./threlte/Map.svelte";
  import { onMount, onDestroy } from "svelte";
  import { usedCameras, submitCameras, move_state, camera_coords, sideViewMode, activeCameras, simMode, camera_angles, move_over, pending_moves, selectionMode } from "src/stores";
  import type { Action, Move, C_Move} from "src/stores";
  import { get } from 'svelte/store';
  import PointerLockControls from './threlte/PointerLockControls.svelte'
  import * as THREE from 'three';
  import Bullet from './threlte/Bullet.svelte';  // Add this import
  import { writable } from 'svelte/store';
  import { derived } from "svelte/store";
  import { glob } from "fs";
  import { fast_cos, fast_sin} from "src/trig.ts"

  const CAMERA_HEIGHT = 2;
  const MESH_HEIGHT = 0.5;

  const ownedCameras = derived(camera_coords, $camera_coords => {
        const cameraArray = Object.values($camera_coords);
        return cameraArray.filter(camera => camera.isOwner);
    });
  let cameras: any = [];
  let cameraMeshes: any = [];
  let sideViewCamera: any;
  let activeCamerasList = get(activeCameras);
  const { renderer, scene } = useThrelte();

  let moveSpeed = 0.5; // Speed at which cameras will move

  const keyState = {
    w: false,
    a: false,
    s: false,
    d: false,
    forward: false,
    backward: false,
    left: false,
    right: false,
  };

  let isMouseDown = false;
  let worldPosition = new THREE.Vector3();
  let cooldown = 0;
  let frame_counter = 0;
  let turn_over = false;
  let moves: any[] = [];
  let bullets: any[] = [];
  let bulletsStore = writable([]);

  $: progressWidth = Math.min((frame_counter / 300) * 100, 100);

  function truncateToDecimals(num: number, decimalPlaces: number) {
    const multiplier = Math.pow(10, decimalPlaces);
    return Math.floor(num * multiplier) / multiplier;
  }

  function updateBullet(bullet: any) {
    let x_change = bullet.speed * fast_cos(bullet.angle * 10_000_000);
    let y_change = bullet.speed * fast_sin(bullet.angle * 10_000_000);
    bullet.position.x += x_change;
    bullet.position.y += y_change;
  }

  function update_all_bullets(bullets: any[]) {
    let new_bullets = []
    for (let i = 0; i<bullets.length; i++) {
      let bullet = bullets[i];
      updateBullet(bullet);
      new_bullets.push(bullet);
      bulletsStore.set(new_bullets);
    }
  }

  function handleKeyDown(event) {
    if (event.key === 'w' || event.key === 'a' || event.key === 's' || event.key === 'd') {
      keyState[event.key] = true;
    }
    switch (event.key.toLowerCase()) {
      case 'w':
        keyState.forward = true;
        break;
      case 's':
        keyState.backward = true;
        break;
      case 'a':
        keyState.left = true;
        break;
      case 'd':
        keyState.right = true;
        break;
    }
  }

  function handleKeyUp(event) {
    if (event.key === 'w' || event.key === 'a' || event.key === 's' || event.key === 'd') {
      keyState[event.key] = false;
    }
    switch (event.key.toLowerCase()) {
      case 'w':
        keyState.forward = false;
        break;
      case 's':
        keyState.backward = false;
        break;
      case 'a':
        keyState.left = false;
        break;
      case 'd':
        keyState.right = false;
        break;
    }
  }

  function handleMouseDown(event: MouseEvent) {
    if (event.button === 0) {
      // Left mouse button
      isMouseDown = true;
    }
  }

  function handleMouseUp(event: MouseEvent) {
    if (event.button === 0) {
      // Left mouse button
      isMouseDown = false;
    }
  }

  let matchingIndices: any = [];

  $: {
      const activeCamerasList = $activeCameras;
      const ownedCamerasList = $ownedCameras;

      matchingIndices = ownedCamerasList.reduce((indices, camera, index) => {
          if (activeCamerasList.includes(camera.id)) {
              indices.push(index);
          }
          return indices;
      }, []);
  }


  function moveCameras() {
    const isSimMode = get(simMode);

    if (!isSimMode || turn_over) return;

    const moveVector = new THREE.Vector3();
    $activeCameras.forEach((cameraIndex, i) => {
      const camera = cameras[matchingIndices[i]];

      moveVector.set(0, 0, 0);

      if (keyState.w) moveVector.z -= moveSpeed;
      if (keyState.s) moveVector.z += moveSpeed;
      if (keyState.a) moveVector.x -= moveSpeed;
      if (keyState.d) moveVector.x += moveSpeed;

      moveVector.applyQuaternion(camera.quaternion); // Apply camera's rotation to the movement vector
      moveVector.y = 0; // Prevent movement in the up/down direction

      camera.position.add(moveVector);
      if (cameraMeshes[i]) {
        cameraMeshes[i].position.copy(camera.position);
      }
    });
  }

  function renderCameras() {
    const { width, height } = renderer.domElement;
    const isSideViewMode = get(sideViewMode);
    const isSimMode = get(simMode);
    const activeCamerasList = get(activeCameras);

    moveCameras(); // Update camera positions based on controls

    if (isSideViewMode) {
      // Render side view mode
      if (sideViewCamera) {
        sideViewCamera.aspect = width / height;
        sideViewCamera.updateProjectionMatrix();

        renderer.setScissorTest(false);
        renderer.setViewport(0, 0, width, height);
        renderer.render(scene, sideViewCamera);
      }
    } else if (isSimMode) {
      // Render only active cameras in sim mode
      const gridColumns = Math.ceil(Math.sqrt(activeCamerasList.length));
      const gridRows = Math.ceil(activeCamerasList.length / gridColumns);
      const viewWidth = Math.floor(width / gridColumns);
      const viewHeight = Math.floor(height / gridRows);

      activeCamerasList.forEach((cameraIndex, i) => {
        const camera = cameras[matchingIndices[i]];
        const col = i % gridColumns;
        const row = Math.floor(i / gridColumns);
        camera.aspect = viewWidth / viewHeight;
        camera.updateProjectionMatrix();

        const x = col * viewWidth;
        const y = height - (row + 1) * viewHeight; // Invert Y-axis to start from bottom

        renderer.setScissorTest(true);
        renderer.setViewport(x, y, viewWidth, viewHeight);
        renderer.setScissor(x, y, viewWidth, viewHeight);
        renderer.render(scene, camera);
      });

      renderer.setScissorTest(false);
    } else if (cameras.length === 8) {
      // Render multi-camera view
      const gridColumns = 4;
      const gridRows = 2;
      const viewWidth = Math.floor(width / gridColumns);
      const viewHeight = Math.floor(height / gridRows);

      for (let i = 0; i < cameras.length; i++) {
        const col = i % gridColumns;
        const row = Math.floor(i / gridColumns);

        cameras[i].aspect = viewWidth / viewHeight;
        cameras[i].updateProjectionMatrix();

        const x = col * viewWidth;
        const y = height - (row + 1) * viewHeight; // Invert Y-axis to start from bottom

        renderer.setScissorTest(true);
        renderer.setViewport(x, y, viewWidth, viewHeight);
        renderer.setScissor(x, y, viewWidth, viewHeight);
        renderer.render(scene, cameras[i]);
      }

      renderer.setScissorTest(false);
    }
  }

  let globalFrameCounter = 0;


function updateLogic() {
  if (turn_over) return;
  if (!$simMode) return;
  const activeCamerasList = get(activeCameras);
  let anyMovementOrAction = false; // Track if any movement or action occurs

  // Only consider the first active camera
  const camera = cameras[0];
  if (!camera) return;

  const moveDirection = new THREE.Vector3();

  if (keyState.forward) moveDirection.z -= 1;
  if (keyState.backward) moveDirection.z += 1;
  if (keyState.left) moveDirection.x -= 1;
  if (keyState.right) moveDirection.x += 1;

  // Check if there's any movement or if the mouse is down (indicating a potential shooting action)
  if (moveDirection.length() > 0 || isMouseDown) {
    anyMovementOrAction = true;
    moveDirection.normalize().multiplyScalar(moveSpeed);
    moveDirection.applyQuaternion(camera.quaternion);
    moveDirection.x = truncateToDecimals(moveDirection.x, 2);
    moveDirection.z = truncateToDecimals(moveDirection.z, 2);
    // Record movement and other actions every 3 frames
    if (globalFrameCounter % 3 === 0) {
      if (cooldown > 0) {
        cooldown -= 1;
      }

      if (globalFrameCounter === 300) {
        turn_over = true;
        document.exitPointerLock();
        console.log(moves);
        console.log(bullets);
        let actions: Action[] = [{ action_type: 0, step: 4 }]; // actions are hard coded for now
        let c_moves: C_Move = { characters: get(activeCameras), moves, actions };
        if ($move_state >= 3) {
          move_over.set(true);
        } else {
          move_state.update(state => state + 1);
          selectionMode.set(true);
          simMode.set(false);
          turn_over = false;
          globalFrameCounter = 0;
        }
        submitCameras.update(currentArray => [...currentArray, c_moves]);
        pending_moves.set([c_moves]);
      }


      if (isMouseDown) {
        if (bullets.length < 5 && cooldown === 0) {
          let cam_position = camera.getWorldPosition(worldPosition).clone();
          cam_position.x = truncateToDecimals(cam_position.x, 2);
          cam_position.z = truncateToDecimals(cam_position.z, 2);

          cam_position.x = cam_position.x * 100;
          cam_position.z = cam_position.z * 100;

          // Calculate direction in degrees
          let direction = Math.atan2(camera.getWorldDirection(new THREE.Vector3()).x, camera.getWorldDirection(new THREE.Vector3()).z) * (180 / Math.PI);
          direction = Math.round((direction + 360) % 360);
          let bullet = {
            x: Math.round(cam_position.x),
            y: Math.round(cam_position.z),
            frame: globalFrameCounter,
            direction: direction,
          };
          bullets.push(bullet);
          bulletsStore.update(currentBullets => [...currentBullets, bullet]);
          cooldown = 3;
        }
      }

      // Calculate movement since the last frame
      let move = {
        x: Math.abs(Math.round(moveDirection.x * 100)),
        y: Math.abs(Math.round(moveDirection.z * 100)),
        xdir: moveDirection.x >= 0,
        ydir: moveDirection.z >= 0,
      };
      moves.push(move);

      // Reset moveDirection for the next frame
      moveDirection.set(0, 0, 0);
    }
  }

  // Only increment the frame counter if there was any movement or action
  if (anyMovementOrAction) {
    globalFrameCounter += 1;
  }
}

  onMount(() => {
    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);
    window.addEventListener('mousedown', handleMouseDown);
    window.addEventListener('mouseup', handleMouseUp);
    renderer.setAnimationLoop(() => {
      updateLogic();
      renderCameras();
    });
  });

  onDestroy(() => {
    window.removeEventListener('keydown', handleKeyDown);
    window.removeEventListener('keyup', handleKeyUp);
    window.removeEventListener('mousedown', handleMouseDown);
    window.removeEventListener('mouseup', handleMouseUp);
    renderer.setAnimationLoop(null);
  });
</script>

<World>
  <Game />

    <!-- Setup 8 Cameras for Multi-Camera View -->
    {#each $ownedCameras as camera, i}
    {#if !$sideViewMode}
      <T.PerspectiveCamera
        position={[camera.coords[0], CAMERA_HEIGHT, camera.coords[1]]}
        on:create={({ ref }) => {
          cameras[i] = ref;
          ref.lookAt(camera.coords[0] + 1, CAMERA_HEIGHT, camera.coords[1]);
          // Store initial camera angles
          camera_angles.update(angles => {
            angles[i] = [ref.rotation.x, ref.rotation.y, ref.rotation.z];
            return angles;
          });
        }}
      >
      <PointerLockControls />
      </T.PerspectiveCamera>
      {/if}

      <T.Mesh
      position={[camera.coords[0], MESH_HEIGHT, camera.coords[1]]}
      rotation={cameras[i] ? cameras[i].rotation : [0, 0, 0]}
        on:create={({ ref }) => {
          cameraMeshes[i] = ref;
        }}
      >
        <T.BoxGeometry args={[1, 1, 1]} />
        <T.MeshBasicMaterial color="#00ff00" />
      </T.Mesh>
    {/each}

  {#if $sideViewMode}
    <!-- Side View Camera -->
    <T.PerspectiveCamera
      position={[0, 100, 0]}  
      on:create={({ ref }) => {
        sideViewCamera = ref;
        ref.lookAt(0, 0, 0);  
      }}
    />
  {/if}

  <!-- Update this section to use the reactive store -->
  {#each $bulletsStore as bullet}
  
    <Bullet x={bullet.x / 100} y={bullet.y / 100} />
  {/each}
</World>
