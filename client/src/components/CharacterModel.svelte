<script lang="ts">
    import { T } from "@threlte/core";
    import { setupStore } from "src/main";
    import { createComponentValueStore } from "src/dojo/componentValueStore";
    import { derived } from "svelte/store";
    import { camera_coords } from "src/stores";
    import type { Writable } from "svelte/store";

    export let id: number = 0;
    let entity: string | undefined;
    let character: Writable<any>;
    let position: Writable<any>;
    let account: any;

    // Subscribing to the setupStore and setting up necessary variables
    $: ({ clientComponents, torii, burnerManager, client } = $setupStore);

    $: entity = derived(setupStore, ($store) =>
        $store ? torii.poseidonHash([BigInt(id).toString()]) : undefined
    );

    // Update account if burnerManager is available
    $: if (burnerManager) account = burnerManager.getActiveAccount();

    // Create stores for character and position
    $: character = entity ? createComponentValueStore(clientComponents.Character, entity) : undefined;
    $: position = entity ? createComponentValueStore(clientComponents.Position, entity) : undefined;

    // Update camera coordinates if necessary
    $: if ($position && $character && account) {
        if ($character.player_id === AddressToBigInt(account.address)) {
            camera_coords.update(coords => {
                coords = [...coords, [$position.x / 100 - 51, $position.y / 100 - 51]];
                return coords;
            });
        }
    }

    // Helper function to convert an address to BigInt
    function AddressToBigInt(address: string): bigint {
        if (!address.startsWith('0x')) {
            address = '0x' + address;
        }
        return BigInt(address);
    }
</script>

{#if $character && $position && account}
    <T.Mesh position={[$position.x / 100 - 51, 0.5, $position.y / 100 - 51]}>
        <T.BoxGeometry />
        <T.MeshStandardMaterial color="red" />
    </T.Mesh>
{/if}



