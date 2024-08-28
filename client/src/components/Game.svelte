<script lang="ts">
    import { T, useTask } from '@threlte/core'
    import Character from './Character.svelte'
    import Ground from './Ground.svelte'
    import { Mesh, Vector3 } from 'three'
    import { spring } from 'svelte/motion';


    let playerMesh: T.Mesh
    let positionHasBeenSet = false
    const smoothPlayerPosX = spring(0)
    const smoothPlayerPosZ = spring(0)
    const t3 = new Vector3()

    useTask(() => {
      if (!playerMesh) return
      console.log($playerMesh)
      let t3 = playerMesh.position()
      smoothPlayerPosX.set(t3.x, {
      hard: !positionHasBeenSet
      })
      smoothPlayerPosZ.set(t3.z, {
      hard: !positionHasBeenSet
      })
      if (!positionHasBeenSet) positionHasBeenSet = true
    })
  
  </script>


<T.DirectionalLight castShadow position={[3, 10, 10]} />
<T.AmbientLight intensity={0.2} />
	<Ground />

  <Character
      bind:this={playerMesh}
      position={[0, 2, 0]}
  />
