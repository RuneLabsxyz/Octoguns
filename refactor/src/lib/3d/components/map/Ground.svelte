<script lang="ts">
  import { T } from '@threlte/core'
  import * as THREE from 'three'

  const textureLoader = new THREE.TextureLoader()
  const tileTexture = textureLoader.load('/sprites/ground.png')

  tileTexture.wrapS = THREE.RepeatWrapping
  tileTexture.wrapT = THREE.RepeatWrapping
  tileTexture.repeat.set(20, 20)
</script>

<T.Mesh receiveShadow position={[0, -0.5, 0]}>
  <T.BoxGeometry args={[100, 1, 100]} />
  <T.MeshStandardMaterial map={tileTexture} />
</T.Mesh>
