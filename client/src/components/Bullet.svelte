<script lang="ts">
    import {T} from "@threlte/core";
    import { CylinderGeometry, MeshStandardMaterial, SphereGeometry } from "three";

    export let color = "red"
    export let x = 0
    export let y = 0

</script>

<T.Mesh position = {[x, 2, y]} scale={.1}>
    <T.SphereGeometry />
    <T.MeshStandardMaterial color={color} />
</T.Mesh>
