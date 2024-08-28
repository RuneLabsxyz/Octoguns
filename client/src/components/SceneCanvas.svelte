<script lang="ts">
  import { T, useThrelte, useFrame } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./Game.svelte";
  import { onMount, onDestroy } from "svelte";
  import { camera_coords, sideViewMode, activeCameras, simMode, camera_angles, move_over, pending_moves } from "src/stores";
  import { get } from 'svelte/store';
  import PointerLockControls from './PointerLockControls.svelte'
  import * as THREE from 'three';

  const CAMERA_HEIGHT = 2;
  const MESH_HEIGHT = 0.5;

  let cameras: any = [];
  let cameraMeshes: any = [];
  let sideViewCamera: any;
  const { renderer, scene } = useThrelte();

  $: console.log('angles', $camera_angles)

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
  let bullets: any = [];
  let cooldown = 0;
  let frame_counter = 0;
  let turn_over = false;
  let moves: any[] = [];

  $: progressWidth = Math.min((frame_counter / 300) * 100, 100);

  function truncateToDecimals(num: number, decimalPlaces: number) {
    const multiplier = Math.pow(10, decimalPlaces);
    return Math.floor(num * multiplier) / multiplier;
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

  function moveCameras() {
    const isSimMode = get(simMode);

    if (!isSimMode || turn_over) return;

    let activeCamerasList = get(activeCameras);
    const moveVector = new THREE.Vector3();

    activeCamerasList.forEach((cameraIndex) => {
      const camera = cameras[cameraIndex];
      moveVector.set(0, 0, 0);

      if (keyState.w) moveVector.z -= moveSpeed;
      if (keyState.s) moveVector.z += moveSpeed;
      if (keyState.a) moveVector.x -= moveSpeed;
      if (keyState.d) moveVector.x += moveSpeed;

      moveVector.applyQuaternion(camera.quaternion); // Apply camera's rotation to the movement vector
      moveVector.y = 0; // Prevent movement in the up/down direction

      camera.position.add(moveVector);
      if (cameraMeshes[cameraIndex]) {
        cameraMeshes[cameraIndex].position.copy(camera.position);
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
      const viewWidth = width / gridColumns;
      const viewHeight = height / gridRows;

      activeCamerasList.forEach((cameraIndex, i) => {
        const col = i % gridColumns;
        const row = Math.floor(i / gridColumns);

        cameras[cameraIndex].aspect = viewWidth / viewHeight;
        cameras[cameraIndex].updateProjectionMatrix();

        renderer.setScissorTest(true);
        renderer.setViewport(col * viewWidth, row * viewHeight, viewWidth, viewHeight);
        renderer.setScissor(col * viewWidth, row * viewHeight, viewWidth, viewHeight);
        renderer.render(scene, cameras[cameraIndex]);
      });

      renderer.setScissorTest(false);
    } else if (cameras.length === 8) {
      // Render multi-camera view
      const gridColumns = 4;
      const gridRows = 2;
      const viewWidth = width / gridColumns;
      const viewHeight = height / gridRows;

      for (let i = 0; i < cameras.length; i++) {
        const col = i % gridColumns;
        const row = Math.floor(i / gridColumns);

        cameras[i].aspect = viewWidth / viewHeight;
        cameras[i].updateProjectionMatrix();

        renderer.setScissorTest(true);
        renderer.setViewport(col * viewWidth, row * viewHeight, viewWidth, viewHeight);
        renderer.setScissor(col * viewWidth, row * viewHeight, viewWidth, viewHeight);
        renderer.render(scene, cameras[i]);
      }

      renderer.setScissorTest(false);
    }
  }

  function updateLogic() {
  if (turn_over) return;

  const activeCamerasList = get(activeCameras);

  activeCamerasList.forEach((cameraIndex) => {
    const camera = cameras[cameraIndex];
    if (!camera) return;

    const moveDirection = new THREE.Vector3();

    if (keyState.forward) moveDirection.z -= 1;
    if (keyState.backward) moveDirection.z += 1;
    if (keyState.left) moveDirection.x -= 1;
    if (keyState.right) moveDirection.x += 1;

    if (moveDirection.length() > 0 || isMouseDown && cooldown === 0) {
      frame_counter += 1;

      moveDirection.normalize().multiplyScalar(moveSpeed);
      moveDirection.applyQuaternion(camera.quaternion);
      moveDirection.x = truncateToDecimals(moveDirection.x, 2);
      moveDirection.z = truncateToDecimals(moveDirection.z, 2);

      if (frame_counter % 3 === 0) {
        if (cooldown > 0) {
          cooldown -= 1;
        }

        if (frame_counter === 300) {
          turn_over = true;
          document.exitPointerLock();
          console.log(moves);
          console.log(bullets);
          let actions = [{ action_type: 0, step: 4 }];
          let c_moves = { characters: [cameraIndex], moves, actions };
          move_over.set(true);
          pending_moves.set([c_moves]);
        }

        if (isMouseDown) {
          if (bullets.length < 5 && cooldown === 0) {
            console.log('fire');
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
              frame: frame_counter,
              direction: direction,
            };
            bullets = [...bullets, bullet]; 
            cooldown = 1;
          }
        }

        // Calculate movement since the last frame
        let move = {
          dx: Math.round(moveDirection.x * 100),
          dy: Math.round(moveDirection.z * 100),
        };
        moves.push(move);

        // Update bullets
        bullets.forEach((bullet: any, i: any) => {
          // Update bullet position logic here

          // Remove bullets that have traveled too far
          if (Math.sqrt(bullet.x ** 2 + bullet.y ** 2) > 1000) {
            bullets.splice(i, 1);
          }
        });
      }
    }
  });
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

  {#if !$sideViewMode}
    <!-- Setup 8 Cameras for Multi-Camera View -->
    {#each Array(8) as _, i}
      <T.PerspectiveCamera
        position={[0, CAMERA_HEIGHT, 0]}
        on:create={({ ref }) => {
          cameras[i] = ref;
          // If initial camera coordinates are available, set position
          if ($camera_coords[i]) {
            ref.position.set($camera_coords[i][0], CAMERA_HEIGHT, $camera_coords[i][1]);
            ref.lookAt($camera_coords[i][0] + 1, CAMERA_HEIGHT, $camera_coords[i][1]);
          }
          // Store initial camera angles
          camera_angles.update(angles => {
            angles[i] = [ref.rotation.x, ref.rotation.y, ref.rotation.z];
            return angles;
          });
        }}
      >
      <PointerLockControls />
      </T.PerspectiveCamera>
      <T.Mesh
      position={[$camera_coords[i] ? $camera_coords[i][0] : 0, MESH_HEIGHT, $camera_coords[i] ? $camera_coords[i][1] : 0]}
      rotation={cameras[i] ? cameras[i].rotation : [0, 0, 0]}
        on:create={({ ref }) => {
          cameraMeshes[i] = ref;
        }}
      >
        <T.BoxGeometry args={[1, 1, 1]} />
        <T.MeshBasicMaterial color="#00ff00" />
      </T.Mesh>
    {/each}
  {/if}

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
</World>
