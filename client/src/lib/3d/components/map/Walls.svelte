<script lang="ts">
  import * as THREE from 'three'
  import Container from '../models/container.svelte'

  let container: THREE.Group = $state(new THREE.Group())

  function onCreate({ ref }: any) {
    ref.traverse((object: any) => {
      console.log('Traversing object!', object)
      if (object instanceof THREE.Mesh) {
        console.log('material:', object.material)
      }
    })
  }
</script>

<Container
  bind:ref={container}
  on:create={onCreate}
  position={[0, -0.2, 0]}
  scale={0.367}
/>
