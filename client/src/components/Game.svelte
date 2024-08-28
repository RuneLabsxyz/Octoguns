<script lang="ts">
    import { T } from '@threlte/core'
    import { OrbitControls } from '@threlte/extras'
    import { CollisionGroups } from '@threlte/rapier'
	import Character from './Character.svelte'
	import Ground from './Ground.svelte'

    let playerMesh: T.Mesh
  
  </script>


<T.DirectionalLight castShadow position={[3, 10, 10]} />
<T.AmbientLight intensity={0.2} />
  <CollisionGroups groups={[0, 15]}>
	<Ground />
  </CollisionGroups>

  <CollisionGroups groups={[0]}>
    <Character
        bind:playerMesh
        position={[0, 2, 0]}
        on:click={(e) => {
            // Don't stop propagation
            // e.stopPropagation();
        }}
    />
  </CollisionGroups>
