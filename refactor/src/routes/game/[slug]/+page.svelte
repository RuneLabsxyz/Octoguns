<script lang="ts">
    import { Canvas } from '@threlte/core'
    import Scene from '$lib/3d/Scene.svelte';
    import Ui from '$lib/ui/Ui.svelte';
    import { componentValueStore } from "../../../dojo/componentValueStore";
    import { dojoStore, accountStore } from "../../../stores/dojoStore";
    import { gameState, sessionId, characterIds, recordedMove, isMoveRecorded,
            playerCharacterCoords, 
            enemyCharacterCoords, 
            setPlayerCharacterCoords, 
            setEnemyCharacterCoords } from '../../../stores/gameStores';
    import { areAddressesEqual } from '$lib/helper.';
    import type { Account } from 'starknet';
    import { move } from '../../../dojo/createSystemCalls';
    import { type TurnData } from '../../../stores/gameStores';
    import { type ComponentStore } from '../../../dojo/componentValueStore';

    export let data;
    let gameId = data.gameId;
    let account: Account;
    let calldata : TurnData;
    let characterData: ComponentStore;
    let characterPosition: ComponentStore;

    $: sessionId.set(parseInt(gameId));

    $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as any);

    $: if ($accountStore) account = $accountStore;

	$: sessionEntity = torii.poseidonHash([BigInt(gameId).toString()]);

    $: sessionData = componentValueStore(clientComponents.Session, sessionEntity);
    $: sessionMetaData = componentValueStore(clientComponents.SessionMeta, sessionEntity);

    $: gameState.set($sessionData.state);
    $: console.log($isMoveRecorded);

    // Some logs to see what's going on
    $: console.log("session", $sessionData);
    $: console.log("sessionMeta", $sessionMetaData);
    $: console.log("sessionMeta bullets", $sessionMetaData.bullets);

    $: if ($sessionMetaData) characterIds.set([$sessionMetaData.p1_character, $sessionMetaData.p2_character]);
    $: if ($isMoveRecorded) calldata = { sub_moves: $recordedMove.sub_moves, shots: $recordedMove.shots };
    // Extract character data w/ characterIds
    $: if ($characterIds) {
        console.log($characterIds)
        $characterIds.forEach(characterId => {
            $: if (characterId) {
                console.log(characterId)
                let characterEntity = torii.poseidonHash([BigInt(characterId).toString()]);
                characterData = componentValueStore(clientComponents.CharacterModel, characterEntity);
                characterPosition =  componentValueStore(clientComponents.CharacterPosition, characterEntity);
                

                characterPosition.subscribe(position => {
                    let res = areAddressesEqual($characterData.player_id, account.address);
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

<div class="absolute top-0 left-0 w-full h-full z-10 pointer-events-none">
    <Ui />  
    {#if $isMoveRecorded}
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 pointer-events-auto">
            <button 
                class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition"
                on:click={() => move(client, account, $sessionId, calldata)}
            >
                Submit Move
            </button>
        </div>
    {/if}
</div>
<div class="absolute h-full w-full">
    <Canvas>
        <Scene />
    </Canvas>
</div>