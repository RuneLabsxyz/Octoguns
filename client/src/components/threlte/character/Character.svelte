<script lang="ts">
    import { T, useFrame, useThrelte } from '@threlte/core'
  import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier'
  import { PerspectiveCamera, Vector2, Vector3 } from 'three'
  import PointerLockControls from '../PointerLockControls.svelte'
  import Gun from './Gun.svelte'
    import type { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat'
    import { writable } from 'svelte/store'
    import { Bullet } from 'src/dojo/typescript/models.gen'
    import * as THREE from 'three'
    import { move_over, pending_moves } from 'src/stores';
  //  import { bullets, characters } from 'src/stores'

  export let position: [number, number, number] = [0, 0, 0]

  let playerMesh: T.Mesh;

  interface Bullet {
    x: number;
    y: number;
    direction: THREE.Quaternion;
    speed: number;
    id: number;
  }

  let cam: PerspectiveCamera;
  let moveDirection = new Vector3();
  let speed = 5;
  let previous_move = [0, 0, 0];
  let moves: any[] = [];
  let interval = 0.05;
  let turn_length = 600;
  let isMouseDown = false;
  let worldPosition = new THREE.Vector3();
  let { burnerManager, client } = $setupStore;
  let bullets: Bullet[] = [];
  let cooldown = 0;
  let frame_counter = 0;

  $: progressWidth = Math.min((frame_counter / 300) * 100, 100);

  const keyState = {
    forward: false,
    backward: false,
    left: false,
    right: false,
  };

  function handleKeyDown(event: KeyboardEvent) {
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

  function handleKeyUp(event: KeyboardEvent) {
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

  let turn_over = false;

  function truncateToDecimals(num: number, decimalPlaces: number) {
    const multiplier = Math.pow(10, decimalPlaces);
    return Math.floor(num * multiplier) / multiplier;
  }

  useFrame((_, delta) => {
    if (!playerMesh || !cam) return;
    moveDirection.set(0, 0, 0);

    if (keyState.forward) moveDirection.z -= 1;
    if (keyState.backward) moveDirection.z += 1;
    if (keyState.left) moveDirection.x -= 1;
    if (keyState.right) moveDirection.x += 1;

        if (moveDirection.length() > 0) {
          frame_counter += 1;

          moveDirection.normalize().multiplyScalar(speed)
          moveDirection.applyQuaternion(cam.quaternion);
          moveDirection.x = truncateToDecimals(moveDirection.x, 2);
          moveDirection.z = truncateToDecimals(moveDirection.z, 2);

          if (frame_counter % 3 == 0 && !turn_over) {
            if (cooldown > 0){
              cooldown -=1;
            }
            if (frame_counter == 300) {
              turn_over = true;
              document.exitPointerLock();
              console.log(moves)
              console.log(bullets)
              let actions = [{ action_type: 0, step: 4 }];
              let session_id = 0;
              let c_moves = { characters: [0], moves, actions };
              move_over.set(true)
              pending_moves.set([c_moves]);

            }
            if (isMouseDown) {
              if ( bullets.length < 5 && cooldown == 0) {
                //TODO make sure to normailze so that (0,0) is corner rather than center
                let cam_position = cam.getWorldPosition(worldPosition).clone()
                cam_position.x = truncateToDecimals(cam_position.x, 2);
                cam_position.z = truncateToDecimals(cam_position.z, 2);
                console.log(cam_position)

                let position: [number, number] = [cam_position.x, cam_position.z]
                let bullet: Bullet = {x: position[0], y: position[1], direction: cam.quaternion.clone(), speed: 25, id:(frame_counter%3)};
                console.log(bullet)

            bullets.push(bullet);
            cooldown = 5;
          }
        }

            let move = {x: Math.round(moveDirection.x * 100), y: Math.round(moveDirection.z * 100)}
            moves.push(move);

        const pos = playerMesh.position;
        console.log(pos)
        position = [pos.x, pos.y, pos.z];

        // Update bullets
        for (let i = 0; i < bullets.length; i++) {
          let bullet = bullets[i];
          // Calculate the displacement
          //TODO use fast_sin / fast_cos to match cairo logic
          
          
          // Update the bullet's position
    //      bullet.x += truncateToDecimals(bullet.direction.fast_cos * bullet.velocity * delta, 2);
    //      bullet.y += truncateToDecimals(bullet.direction.fast_sin * bullet.velocity * delta,2);
          

          // Optional: Remove bullets that have traveled too far
          if (Math.sqrt(bullet.x**2 + bullet.y**2) > 1000) { // Adjust this value as needed
            bullets.splice(i, 1);
            i--;
          }
        }
      }
    }
  });

  const { renderer } = useThrelte();

  function lockControls() {
    if (document.pointerLockElement !== renderer.domElement) {
      renderer.domElement.requestPointerLock();
    }
  }

  renderer.domElement.addEventListener('click', lockControls);
</script>

<svelte:window
  on:keydown={handleKeyDown}
  on:keyup={handleKeyUp}
  on:mousedown={handleMouseDown}
  on:mouseup={handleMouseUp}
/>

<div class="progress-container">
  <div class="progress-bar" style="width: {progressWidth}%"></div>
</div>

{#if turn_over}
  <div class="over-container">
    <button
      class="over-button"
      on:click={() => {
        let actions = [{ action_type: 0, step: 4 }];
        let session_id = 0;
        let c_moves = { characters: [4], moves, actions };
        client.actions.move({
          account: burnerManager.account,
          session_id,
          moves: c_moves,
        });
      }}
    >
      End Turn
    </button>
  </div>
{/if}

<T.Group {position}>
  <T.PerspectiveCamera
    makeDefault
    fov={90}
    bind:ref={cam}
    position={[0, 1.7, 0]}
    enabledRotations={[true, false, true]}
  >
    <PointerLockControls />
    <Gun position={new Vector3(0.8, -0.65, -0.75)} />
  </T.PerspectiveCamera>

  <T.Mesh bind:this={playerMesh} let:ref castShadow>
    <T.BoxGeometry args={[1, 2, 1]} />
    <T.MeshStandardMaterial color="blue" />
    {#if ref }
      {console.log(ref)}
    {/if}
  </T.Mesh>
</T.Group>

<style>
  .progress-container {
    width: 100%;
    height: 10px;
    background-color: rgba(240, 240, 240, 0.5);
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
    pointer-events: none;
  }

  .progress-bar {
    height: 100%;
    background-color: #4caf50;
    transition: width 0.3s ease;
  }

  .over-button {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 10px 20px;
    font-size: 18px;
    background-color: #4caf50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    z-index: 10;
  }
</style>
