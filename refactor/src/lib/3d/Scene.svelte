<script lang="ts">
    import { T } from '@threlte/core';
    import Map from './Map.svelte';
    import Cameras from './Cameras.svelte';
    import Characters from './Characters.svelte';
</script>

<T.Group>
    <Cameras />
    <Map />
    <Characters />
</T.Group>
