<script lang="ts">
    import { playerCharacterCoords, enemyCharacterCoords } from "../../../stores/gameStores";
    import { T } from "@threlte/core";
    import { type CharacterCoordsStore } from "../../../stores/gameStores";

    let player_coords: CharacterCoordsStore;
    let enemy_coords: CharacterCoordsStore;

    $: player_coords = $playerCharacterCoords;
    $: enemy_coords = $enemyCharacterCoords;

</script>

<T.Group>
    <T.Group>
        {#each Object.entries(player_coords) as [key, data]}
            <T.Mesh position={[data.x, 0, data.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="blue" />
            </T.Mesh>
        {/each}
    </T.Group>
    <T.Group>
        {#each Object.entries(enemy_coords) as [key, data]}
            <T.Mesh position={[data.x, 0, data.y]} key={key}>
                <T.BoxGeometry args={[1, 1, 1]} />
                <T.MeshStandardMaterial color="red" />
            </T.Mesh>
        {/each}
    </T.Group>
</T.Group>
