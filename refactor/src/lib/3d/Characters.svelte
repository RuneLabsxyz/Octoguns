<script lang="ts">
    import { playerCharacterCoords, enemyCharacterCoords } from "../../stores/gameStores";
    import { T } from "@threlte/core";

</script>

<T.Group>
    <T.Group>
        {#each Object.entries($playerCharacterCoords) as [key, data]}
            <T.Mesh position={[data.staged.x, 0, data.staged.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="blue" />
            </T.Mesh>
        {/each}
    </T.Group>
    <T.Group>
        {#each Object.entries($enemyCharacterCoords) as [key, data]}
            <T.Mesh position={[data.staged.x, 0, data.staged.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="red" />
            </T.Mesh>
        {/each}
    </T.Group>
</T.Group>
