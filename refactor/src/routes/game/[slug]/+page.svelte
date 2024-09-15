<script lang="ts">
  import { Canvas } from '@threlte/core'
  import Scene from '$lib/3d/Scene.svelte'
  import Ui from '$lib/ui/Ui.svelte'
  import { componentValueStore } from '$dojo/componentValueStore'
  import { dojoStore, accountStore } from '$stores/dojoStore'
  import {
    gameState,
    sessionId,
    characterIds,
    recordedMove,
    isMoveRecorded,
    setPlayerCharacterCoords,
    setEnemyCharacterCoords,
    playerCharacterId,
    enemyCharacterId,
    playerStartCoords,
  } from '$stores/gameStores'
  import { areAddressesEqual } from '$lib/helper'
  import type { Account } from 'starknet'
  import { move } from '$dojo/createSystemCalls'
  import { type TurnData } from '$stores/gameStores'
  import { type ComponentStore } from '$dojo/componentValueStore'
  import { type SetupResult } from '$src/dojo/setup.js'

  export let data
  let gameId = data.gameId
  let account: Account
  let calldata: TurnData
  let characterData: ComponentStore
  let characterPosition: ComponentStore

  $: sessionId.set(parseInt(gameId))

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore as SetupResult)

  $: if ($accountStore) account = $accountStore

  $: sessionEntity = torii.poseidonHash([BigInt(gameId).toString()])

  $: sessionData = componentValueStore(clientComponents.Session, sessionEntity)
  $: sessionMetaData = componentValueStore(
    clientComponents.SessionMeta,
    sessionEntity
  )

  $: gameState.set($sessionData.state)
  $: console.log($isMoveRecorded)

  // Some logs to see what's going on
  $: console.log('session', $sessionData)
  $: console.log('sessionMeta', $sessionMetaData)
  $: console.log('sessionMeta bullets', $sessionMetaData.bullets)

  $: if ($sessionMetaData)
    characterIds.set([
      $sessionMetaData.p1_character,
      $sessionMetaData.p2_character,
    ])
  $: if ($isMoveRecorded)
    calldata = {
      sub_moves: $recordedMove.sub_moves,
      shots: $recordedMove.shots,
    }
  // Extract character data w/ characterIds
  $: if ($characterIds) {
    console.log('cahracter ids', $characterIds)
    $characterIds.forEach((characterId) => {
      if (characterId) {
        console.log(characterId)
        let characterEntity = torii.poseidonHash([
          BigInt(characterId).toString(),
        ])
        characterData = componentValueStore(
          clientComponents.CharacterModel,
          characterEntity
        )
        console.log('characterData', $characterData)
        characterPosition = componentValueStore(
          clientComponents.CharacterPosition,
          characterEntity
        )
        console.log('characterPosition', $characterPosition)

        characterPosition.subscribe((position) => {
          if ($characterData) {
            let isPlayer = areAddressesEqual(
              $characterData.player_id,
            account.address
          )
          if (isPlayer) {
            playerStartCoords.set(position.coords)
            setPlayerCharacterCoords(characterId, position.coords)
            playerCharacterId.set(characterId)
          } else {
            setEnemyCharacterCoords(characterId, position.coords)
            enemyCharacterId.set(characterId)
          }
          }
        })
      }
    })
  }

  function handleMove() {
    move(client, account, $sessionId, calldata)
    console.log('calldata', calldata)
  }
</script>

<div class="absolute top-0 left-0 w-full h-full z-10 pointer-events-none">
  <Ui moveHandler={handleMove} />
</div>
<div class="absolute h-full w-full">
  <Canvas>
    <Scene />
  </Canvas>
</div>
