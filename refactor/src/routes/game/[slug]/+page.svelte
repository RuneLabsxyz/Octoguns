<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { componentValueStore } from "../../../dojo/componentValueStore";
    import { dojoStore, accountStore } from "../../../stores/dojoStore";
    import { gameState, sessionId, characterIds, playerCharacterCoords, enemyCharacterCoords, setPlayerCharacterCoords, setEnemyCharacterCoords } from '../../../stores/gameStores';
    import { areAddressesEqual } from '$lib/helper.';
    import type { Account } from 'starknet';

    export let data;
    let gameId = data.gameId;
    let account: Account;

    $: sessionId.set(parseInt(gameId));

    $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any);

    $: if ($accountStore) account = $accountStore;

	$: sessionEntity = torii.poseidonHash([BigInt(gameId).toString()]);

    $: sessionData = componentValueStore(clientComponents.Session, sessionEntity);
    $: sessionMetaData = componentValueStore(clientComponents.SessionMeta, sessionEntity);

    $: gameState.set($sessionData.state);

    // Some logs to see what's going on
    $: console.log("session", $sessionData);
    $: console.log("sessionMeta", $sessionMetaData);
    $: console.log("sessionMeta bullets", $sessionMetaData.bullets);

    $: if ($sessionMetaData) characterIds.set([$sessionMetaData.pl_character, $sessionMetaData.p2_character]);


    // Extract character data w/ characterIds
    $: if ($characterIds) {
        $characterIds.forEach(characterId => {
            if (characterId) {
                let characterEntity = torii.poseidonHash([BigInt(characterId).toString()]);
                let characterData = componentValueStore(clientComponents.CharacterModel, characterEntity);
                let characterPosition =  componentValueStore(clientComponents.CharacterPosition, characterEntity);
                // To get the actual data, you can subscribe to the store:
                let characterOwner: string;
                characterData.subscribe(characterModel => {
                    characterOwner  = characterModel.player_id;
                });

                characterPosition.subscribe(position => {
                    let res = areAddressesEqual(characterOwner, account.address);
                    if (res) {
                        setPlayerCharacterCoords(characterId, position.coords);
                    } else {
                        setEnemyCharacterCoords(characterId, position.coords);
                    }
                });
            }

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