<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { createComponentValueStore } from "../../../dojo/componentValueStore";
    import { setupStore } from "../../../stores/dojoStore";
    import { gameState, sessionId, characterIds } from '../../../stores/gameStores';
    import { derived } from "svelte/store";

    export let data;
    let gameId = data.gameId;

    $: sessionId.set(gameId)

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore as any);


	$: sessionEntity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(gameId).toString()])
		: undefined
	);

    $: sessionData = createComponentValueStore(clientComponents.Session, sessionEntity);
    $: sessionMetaData = createComponentValueStore(clientComponents.SessionMeta, sessionEntity);

    $: gameState.set($sessionData.state)


    $: console.log("session", $sessionData);
    $: console.log("sessionMeta", $sessionMetaData);

    $: console.log("sessionMeta bullets", $sessionMetaData.bullets)


    // Get all character Ids
    $: if ($sessionMetaData.characters) {
        const characterIdsArray = $sessionMetaData.characters.map((character: { value: any; }) => character.value);
        characterIds.set(characterIdsArray);
    }

    // Extract charcter data
    $: if ($characterIds) {
        $characterIds.forEach(characterId => {
            let characterEntity = derived(setupStore, ($store) =>
                $store
                ? torii.poseidonHash([BigInt(characterId).toString()])
                : undefined
            );
            let characterData = createComponentValueStore(clientComponents.Character, characterEntity);

            // Subscribe to characterData to access the value
            characterData.subscribe(value => {
                console.log("Character Data for ID", characterId, ":", value);
            });
        });
    }

</script>

<div class="absolute h-full w-full z-10 pointer-events-none">
    <Ui />  
</div>
<div class="absolute h-full w-full">
    <Canvas>
        <Scene />
    </Canvas>
</div>