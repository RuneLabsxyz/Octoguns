<script lang="ts">
    import { T } from '@threlte/core'

</script>

<T.Group position={[0, -0.5, 0]}>
        <T.Mesh receiveShadow>
        <T.BoxGeometry args={[100, 1, 100]} />
        <T.MeshStandardMaterial />
        </T.Mesh>
</T.Group>