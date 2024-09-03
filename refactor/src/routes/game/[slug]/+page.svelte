<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { createComponentValueStore } from "../../../dojo/componentValueStore";
    import { setupStore } from "../../../stores/dojoStore";
    import { gameState, sessionId } from '../../../stores/gameStores';
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


    $: console.log("session", $sessionData);
    $: console.log("sessionMeta", $sessionMetaData);

    $: console.log("sessionMeta bullets", $sessionMetaData.bullets)
    $: console.log("sessionMeta characters", $sessionMetaData.characters)

    $: gameState.set($sessionData.state)
    

</script>

<div class="absolute h-full w-full z-10 pointer-events-none">
    <Ui />  
</div>
<div class="absolute h-full w-full">
    <Canvas>
        <Scene />
    </Canvas>
</div>