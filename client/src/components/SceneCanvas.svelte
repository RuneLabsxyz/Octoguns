<script>
  import { Canvas, T, useThrelte } from "@threlte/core";
  import { World } from "@threlte/rapier";
  import Game from "./Game.svelte";
  import { onMount } from "svelte";
  import { camera_coords } from "src/stores";

  let camera1, camera2;

  const { renderer, scene } = useThrelte();

  $: console.log("coords", $camera_coords);

  onMount(() => {
    function renderCameras() {
      const { width, height } = renderer.domElement;

      // Check if cameras are defined
      if (camera1 && camera2) {
        // Update aspect ratio for camera1 and camera2
        camera1.aspect = (width / 2) / height;
        camera1.updateProjectionMatrix();

        camera2.aspect = (width / 2) / height;
        camera2.updateProjectionMatrix();

        // Render First Camera - Left Half
        renderer.setScissorTest(true);
        renderer.setViewport(0, 0, width / 2, height);
        renderer.setScissor(0, 0, width / 2, height);
        renderer.render(scene, camera1);

        // Render Second Camera - Right Half
        renderer.setViewport(width / 2, 0, width / 2, height);
        renderer.setScissor(width / 2, 0, width / 2, height);
        renderer.render(scene, camera2);

        // Reset Scissor Test
        renderer.setScissorTest(false);
      }
    }

    renderer.setAnimationLoop(renderCameras);
  });
</script>

<World>
  <Game />

  <!-- First Camera -->
  <T.PerspectiveCamera
    position={[10, 10, 10]}
    on:create={({ ref }) => {
      camera1 = ref;
      ref.lookAt(0, 1, 0);
    }}
  />

  <!-- Second Camera -->
  <T.PerspectiveCamera
    position={[-10, 10, 10]}
    on:create={({ ref }) => {
      camera2 = ref;
      ref.lookAt(0, 1, 0);
    }}
  />
</World>
