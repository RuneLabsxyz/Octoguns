<script lang="ts">
    import { playerCharacterCoords, enemyCharacterCoords } from "../../stores/gameStores";
    import { T } from "@threlte/core";

</script>

<T.Group>
    <T.Group>
        {#each Object.entries($playerCharacterCoords) as [key, coords]}
            <T.Mesh position={[coords.x, 0, coords.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="blue" />
            </T.Mesh>
        {/each}
    </T.Group>
    <T.Group>
        {#each Object.entries($enemyCharacterCoords) as [key, coords]}
            <T.Mesh position={[coords.x, 0, coords.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="red" />
            </T.Mesh>
        {/each}
    </T.Group>
</T.Group>
