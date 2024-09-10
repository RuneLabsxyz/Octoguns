<script lang="ts">
  import { T } from '@threlte/core'
  import * as THREE from 'three'

  const textureLoader = new THREE.TextureLoader()
  const wallTexture = textureLoader.load('/sprites/wall.png')

  wallTexture.wrapS = THREE.RepeatWrapping
  wallTexture.wrapT = THREE.RepeatWrapping
  wallTexture.repeat.set(20, 5)
</script>

<T.Group position={[0, -0.5, 0]}>
  <T.Mesh position={[-50, 5, 0]} receiveShadow>
    <T.BoxGeometry args={[1, 10, 100]} />
    <T.MeshStandardMaterial map={wallTexture} />
  </T.Mesh>
  <T.Mesh position={[50, 5, 0]} receiveShadow>
    <T.BoxGeometry args={[1, 10, 100]} />
    <T.MeshStandardMaterial map={wallTexture} />
  </T.Mesh>
  <T.Mesh position={[0, 5, -50]} receiveShadow>
    <T.BoxGeometry args={[100, 10, 1]} />
    <T.MeshStandardMaterial map={wallTexture} />
  </T.Mesh>
  <T.Mesh position={[0, 5, 50]} receiveShadow>
    <T.BoxGeometry args={[100, 10, 1]} />
    <T.MeshStandardMaterial map={wallTexture} />
  </T.Mesh>
</T.Group>
