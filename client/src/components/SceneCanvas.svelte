<script lang="ts">
  import { T, useThrelte } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./Game.svelte";
  import { onMount, onDestroy } from "svelte";
  import { camera_coords, sideViewMode, activeCameras, simMode, camera_angles } from "src/stores";
  import { get } from 'svelte/store';
  import PointerLockControls from './PointerLockControls.svelte'

  let cameras: any = [];
  let cameraMeshes: any = [];
  let sideViewCamera;
  const { renderer, scene } = useThrelte();

  $: console.log('angles', $camera_angles)

  let moveSpeed = 0.5; // Speed at which cameras will move

  const keyState = {
    w: false,
    a: false,
    s: false,
    d: false
  };

  function handleKeyDown(event) {
    if (event.key === 'w' || event.key === 'a' || event.key === 's' || event.key === 'd') {
      keyState[event.key] = true;
    }
  }

  function handleKeyUp(event) {
    if (event.key === 'w' || event.key === 'a' || event.key === 's' || event.key === 'd') {
      keyState[event.key] = false;
    }
  }

  function moveCameras() {
    const isSimMode = get(simMode);

    if (!isSimMode) return;

    let activeCamerasList = get(activeCameras);
    const moveVector = { x: 0, z: 0 };

    if (keyState.w) moveVector.x += moveSpeed;
    if (keyState.s) moveVector.x -= moveSpeed;
    if (keyState.a) moveVector.z -= moveSpeed;
    if (keyState.d) moveVector.z += moveSpeed;

    activeCamerasList.forEach((cameraIndex) => {
      cameras[cameraIndex].position.x += moveVector.x;
      cameras[cameraIndex].position.z += moveVector.z;
      if (cameraMeshes[cameraIndex]) {
        cameraMeshes[cameraIndex].position.copy(cameras[cameraIndex].position);
      }
    });
  }

  // Subscribe to the camera_coords store to update camera positions
  camera_coords.subscribe((coords) => {
    if (coords && coords.length > 0) {
      coords.forEach((coord, index) => {
        if (cameras[index]) {
          cameras[index].position.set(coord[0], 10, coord[1]);
          cameras[index].lookAt(coord[0] + 1, 10, coord[1]); // Adjust for 90 degrees rotation
          if (cameraMeshes[index]) {
            cameraMeshes[index].position.set(coord[0], 10, coord[1]);
          }
        }
      });
    }
  });

  // Subscribe to the camera_angles store to update camera angles
  camera_angles.subscribe((angles) => {
    if (angles && angles.length > 0) {
      angles.forEach((angle, index) => {
        if (cameras[index]) {
          cameras[index].rotation.set(angle[0], angle[1], angle[2]);
          if (cameraMeshes[index]) {
            cameraMeshes[index].rotation.set(angle[0], angle[1], angle[2]);
          }
        }
      });
    }
  });

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

  onMount(() => {
    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);
    renderer.setAnimationLoop(renderCameras);
  });

  onDestroy(() => {
    window.removeEventListener('keydown', handleKeyDown);
    window.removeEventListener('keyup', handleKeyUp);
    renderer.setAnimationLoop(null);
  });
</script>

<World>
  <Game />

  {#if !$sideViewMode}
    <!-- Setup 8 Cameras for Multi-Camera View -->
    {#each Array(8) as _, i}
      <T.PerspectiveCamera
        position={[0, 10, 0]}
        on:create={({ ref }) => {
          cameras[i] = ref;
          // If initial camera coordinates are available, set position
          if ($camera_coords[i]) {
            ref.position.set($camera_coords[i][0], 0.5, $camera_coords[i][1]);
            ref.lookAt($camera_coords[i][0] + 1, 0.5, $camera_coords[i][1]);
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
        position={cameras[i] ? cameras[i].position : [0, 0.5, 0]}
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
