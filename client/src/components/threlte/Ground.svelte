<script lang="ts">
    import { T } from '@threlte/core'

</script>

<T.Group position={[0, -0.5, 0]}>
    <T.Mesh receiveShadow>
        <T.BoxGeometry args={[100, 1, 100]} />
        <T.MeshStandardMaterial />
    </T.Mesh>
    <!-- Adding walls -->
    <T.Mesh position={[-50, 5, 0]} receiveShadow>
        <T.BoxGeometry args={[1, 10, 100]} />
        <T.MeshStandardMaterial />
    </T.Mesh>
    <T.Mesh position={[50, 5, 0]} receiveShadow>
        <T.BoxGeometry args={[1, 10, 100]} />
        <T.MeshStandardMaterial />
    </T.Mesh>
    <T.Mesh position={[0, 5, -50]} receiveShadow>
        <T.BoxGeometry args={[100, 10, 1]} />
        <T.MeshStandardMaterial />
    </T.Mesh>
    <T.Mesh position={[0, 5, 50]} receiveShadow>
        <T.BoxGeometry args={[100, 10, 1]} />
        <T.MeshStandardMaterial />
    </T.Mesh>
</T.Group>