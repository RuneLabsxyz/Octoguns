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
    playerCharacterId,
    enemyCharacterId,
    isTurnPlayer,
    frameCounter,
    recordingMode,
    replayMode,
  } from '$stores/gameStores'
  import { 
    playerStartCoords, 
    bulletStart, 
    bulletRender,
    setPlayerCharacterCoords,
    setEnemyCharacterCoords,
    setBulletCoords
  } from '$stores/coordsStores'
  import { areAddressesEqual } from '$lib/helper'
  import type { Account } from 'starknet'
  import { move } from '$dojo/createSystemCalls'
  import { type TurnData } from '$stores/gameStores'
  import { type ComponentStore } from '$dojo/componentValueStore'
  import { type SetupResult } from '$src/dojo/setup.js'
    import { resetBullets } from '$lib/3d/utils/shootUtils.js'
    import BirdView from '$lib/3d/components/Cameras/BirdView.svelte'

  export let data
  let gameId = data.gameId
  let account: Account
  let calldata: TurnData
  let characterData: ComponentStore
  let characterPosition: ComponentStore
  let isTurn: boolean
  $: sessionId.set(parseInt(gameId))

  $: ({ clientComponents, torii, client } = $dojoStore as SetupResult)

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

  $: if ($sessionMetaData) {
    sessionMetaData.subscribe((data) => {
    isTurn = 
    //is player 1 and it's 1s turn
    (areAddressesEqual(
      $sessionData.player1.toString(),
      account.address
    ) && data.turn_count % 2 === 0) 
    || 
    //is player 2 and it's 2s turn
    (areAddressesEqual(
      $sessionData.player2.toString(),
      account.address
    ) && data.turn_count % 2 === 1)
    isTurnPlayer.set(isTurn)
    })
}

  $: if ($sessionMetaData) {
    characterIds.set([
      $sessionMetaData.p1_character,
      $sessionMetaData.p2_character,
    ])
    $sessionMetaData.bullets.forEach((bulletId) => {
      //@ts-ignore Only gives error bc torii gives primtive types and ts thinks it's a number 
      let bulletEntity = torii.poseidonHash([BigInt(bulletId.value).toString()])
      let bulletStore = componentValueStore(clientComponents.Bullet, bulletEntity)
      bulletStore.subscribe((bullet) => {
        let shot_by = areAddressesEqual(bullet.shot_by.toString(), account.address) ? 1 : 2
        let data = {coords: bullet.coords, angle: bullet.angle, id: bullet.bullet_id,  shot_by: shot_by}
        setBulletCoords(data)
      })
    })
  }


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
              playerStartCoords.set({[position.id]: position.coords})
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
    console.log('calldata', calldata)
    move(client, account, $sessionId, calldata);
    frameCounter.set(0)
    recordedMove.set({ sub_moves: [], shots: [] })
    isMoveRecorded.set(false)
    recordingMode.set(false)
    replayMode.set(false)
    bulletStart.set([]);
    bulletRender.set([]);
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
