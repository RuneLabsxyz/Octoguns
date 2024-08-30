<script lang="ts">
    import { T } from '@threlte/core';
    import * as THREE from 'three';
    
    const textureLoader = new THREE.TextureLoader();
    const tileTexture = textureLoader.load('/sprites/ground.png');
    const wallTexture = textureLoader.load('/sprites/wall.png'); 

    tileTexture.wrapS = THREE.RepeatWrapping;
    tileTexture.wrapT = THREE.RepeatWrapping;
    tileTexture.repeat.set(20, 20);

    wallTexture.wrapS = THREE.RepeatWrapping;
    wallTexture.wrapT = THREE.RepeatWrapping;
    wallTexture.repeat.set(20, 5);
</script>

<T.Group position={[0, -0.5, 0]}>
    <!-- Adding lights -->
    <T.AmbientLight intensity={0.5} />
    <T.DirectionalLight position={[10, 10, 10]} intensity={1} castShadow />
    
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
