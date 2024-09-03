<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { createComponentValueStore } from "../../../dojo/componentValueStore";
    import { setupStore } from "../../../stores/dojoStore";
    import { derived } from "svelte/store";

    export let data;
    let gameId = data.gameId;

    $: ({ clientComponents, torii, burnerManager, client } = $setupStore as any);

    $: account = burnerManager.getActiveAccount();

	$: sessionEntity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt(gameId).toString()])
		: undefined
	);

    $: session = createComponentValueStore(clientComponents.Session, sessionEntity);
    $: sessionMeta = createComponentValueStore(clientComponents.SessionMeta, sessionEntity);

    $: console.log("session", $session);
    $: console.log("sessionMeta", $sessionMeta);

</script>

<div class="absolute h-full w-full z-10 pointer-events-none">
    <Ui />  
</div>
<div class="absolute h-full w-full">
    <Canvas>
        <Scene />
    </Canvas>
</div>