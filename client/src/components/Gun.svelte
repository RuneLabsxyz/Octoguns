<script lang="ts">
    import { T } from "@threlte/core";
    import { BoxGeometry, Euler, Mesh, MeshStandardMaterial, Vector3 } from "three";

    export let position: Vector3 = new Vector3(0,0,0);
    const [x,y,z] = position;

    let material = new MeshStandardMaterial({color: "blue"});
</script>

<T.Group position = {[x,y,z]} rotation={[0, Math.PI, 0]}>
    <T.Mesh >
        <T.BoxGeometry args={[.1,.4,.1]}/>
        <T is={material} />
    </T.Mesh>
    <T.Mesh position = {[0, .2, .2]}>
        <T.BoxGeometry args={[.1,.1,.7]}/>
        <T is={material} />
    </T.Mesh>
</T.Group>

