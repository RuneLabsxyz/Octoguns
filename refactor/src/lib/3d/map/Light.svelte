<script lang="ts">
    import { T } from '@threlte/core';
</script>

<T.Group>
    <T.AmbientLight intensity={0.5} />
    <T.DirectionalLight position={[10, 10, 10]} intensity={1} castShadow />
</T.Group>
