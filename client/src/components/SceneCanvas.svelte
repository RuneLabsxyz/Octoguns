<script>
  import { Canvas, T, useThrelte } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./Game.svelte";
  import { onMount } from "svelte";
  import { camera_coords } from "src/stores";

  let cameras = [];
  const { renderer, scene } = useThrelte();

  // Subscribe to the camera_coords store to update camera positions
  $: $camera_coords, (coords) => {
    if (coords && coords.length > 0) {
      coords.forEach((coord, index) => {
        if (cameras[index]) {
          cameras[index].position.set(coord[0], 10, coord[1]);
          // cameras[index].lookAt(0, 1, 0);
        }
      });
    }
  };

  function renderCameras() {
    const { width, height } = renderer.domElement;

    if (cameras.length === 8) {
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

  <!-- Setup 8 Cameras -->
  {#each Array(8) as _, i}
    <T.PerspectiveCamera
      position={[0, 0, 0]}
      on:create={({ ref }) => {
        cameras[i] = ref;
        // If initial camera coordinates are available, set position
        if ($camera_coords[i]) {
          ref.position.set($camera_coords[i][0], 10, $camera_coords[i][1]);
          ref.lookAt(0, 1, 0);
        }
      }}
    />
  {/each}
</World>
