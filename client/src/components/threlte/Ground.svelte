<script lang="ts">
    import { T } from '@threlte/core'
    import * as THREE from 'three'

    const textureLoader = new THREE.TextureLoader();
    const tileTexture = textureLoader.load('/image.png'); // Replace with your actual texture path
    const wallTexture = textureLoader.load('/wall.png'); // Replace with your actual wall texture path

    // Set the repeat and wrapping for a tiled pattern
    tileTexture.wrapS = THREE.RepeatWrapping;
    tileTexture.wrapT = THREE.RepeatWrapping;
    tileTexture.repeat.set(20, 20); // Adjust for the number of tiles you want

    // Set the repeat and wrapping for the wall texture
    wallTexture.wrapS = THREE.RepeatWrapping;
    wallTexture.wrapT = THREE.RepeatWrapping;
    wallTexture.repeat.set(20, 5); // Adjust for the number of tiles you want
</script>

<T.Group position={[0, -0.5, 0]}>
    <!-- Tiled Floor -->
    <T.Mesh receiveShadow>
        <T.BoxGeometry args={[100, 1, 100]} />
        <T.MeshStandardMaterial map={tileTexture} />
    </T.Mesh>
    <!-- Adding walls -->
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
