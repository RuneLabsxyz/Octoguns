<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { componentValueStore } from "../../../dojo/componentValueStore";
    import { dojoStore } from "../../../stores/dojoStore";
    import { gameState, sessionId, characterIds } from '../../../stores/gameStores';
    import { derived } from "svelte/store";

    export let data;
    let gameId = data.gameId;

    $: sessionId.set(parseInt(gameId))

    $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any);

	$: sessionEntity = torii.poseidonHash([BigInt(gameId).toString()])

    $: sessionData = componentValueStore(clientComponents.Session, sessionEntity);
    $: sessionMetaData = componentValueStore(clientComponents.SessionMeta, sessionEntity);

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
            let characterEntity = torii.poseidonHash([BigInt(characterId).toString()])
            let characterData = componentValueStore(clientComponents.Character, characterEntity);

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