<script lang="ts">
  import { T, useThrelte } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./Game.svelte";
  import { onMount } from "svelte";
  import { camera_coords, sideViewMode, activeCameras, simMode } from "src/stores";
  import { get } from 'svelte/store';
  

  let cameras: any = [];
  let sideViewCamera;
  const { renderer, scene } = useThrelte();

  // Subscribe to the camera_coords store to update camera positions
  camera_coords.subscribe((coords) => {
    if (coords && coords.length > 0) {
      coords.forEach((coord, index) => {
        if (cameras[index]) {
          cameras[index].position.set(coord[0], 10, coord[1]);
          cameras[index].lookAt(coord[0] + 1, 10, coord[1]); // Adjust for 90 degrees rotation
        }
      });
    }
  });

  function renderCameras() {
    const { width, height } = renderer.domElement;
    const isSideViewMode = get(sideViewMode);
    const isSimMode = get(simMode);
    const activeCamerasList = get(activeCameras);

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
    renderer.setAnimationLoop(renderCameras);
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
            ref.position.set($camera_coords[i][0], 10, $camera_coords[i][1]);
            ref.lookAt($camera_coords[i][0] + 1, 10, $camera_coords[i][1]);
          }
        }}
      />
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
