<script lang="ts">
  import { run } from 'svelte/legacy'

  import { Canvas } from '@threlte/core'
  import Scene from '$lib/3d/Scene.svelte'
  import Ui from '$lib/ui/Ui.svelte'
  import { componentValueStore } from '$dojo/componentValueStore'
  import { dojoStore } from '$stores/dojoStore'
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
    mapObjects,
    isEnded,
    currentPlayerId,
    turnCount,
  } from '$stores/gameStores'
  import {
    playerStartCoords,
    bulletStart,
    bulletRender,
    bulletInitialPosition,
    bulletRenderOnchain,
    bulletInitialPositionOnchain,
    setBulletInitialPosition,
    setPlayerCharacterCoords,
    setEnemyCharacterCoords,
    setBulletCoords,
  } from '$stores/coordsStores'

  import { Game } from '$lib/api/game'
  import { get } from 'svelte/store'
  import { areAddressesEqual, getBulletPosition } from '$lib/helper'
  import { move } from '$dojo/createSystemCalls'
  import { type TurnData } from '$stores/gameStores'
  import { type ComponentStore } from '$dojo/componentValueStore'
  import { type SetupResult } from '$src/dojo/setup.js'
  import Waiting from '$lib/ui/ingame/Waiting.svelte'
  import { isOutsideMapBoundary } from '$lib/3d/utils/shootUtils'
  import { BULLET_SUBSTEPS } from '$lib/consts'
  import { account } from '$stores/account'
  import { connect } from '$lib/controller'
  import { controllerMainnet, controllerSlot } from '$lib/controller'
  import { env } from '$stores/network'
  import { onMount } from 'svelte'
  import { currentSession, currentSessionId } from '$lib/api/sessions.js'
  import GameComponent from '$lib/ui/Game.svelte'
  import { GameState } from '$lib/api/gameState.js'

  let { data } = $props()

  const gameStorePromise = $state(
    Game(parseInt(data.gameId), $account?.address ?? null)
  )

  let clientComponents: any = $state()
  let torii: any = $state()
  let client: any = $state()
  let globalentity: any
  let player: ComponentStore
  let global: ComponentStore

  run(() => {
    sessionId.set()
  })

  run(() => {
    if ($dojoStore)
      ({ clientComponents, torii, client } = $dojoStore as SetupResult)
  })

  run(() => {
    if (torii) sessionEntity = torii.poseidonHash([BigInt(gameId).toString()])
  })

  let sessionData = $derived(
    componentValueStore(clientComponents.Session, sessionEntity)
  )
  let sessionMetaData = $derived(
    componentValueStore(clientComponents.SessionMeta, sessionEntity)
  )

  run(() => {
    if ($sessionData)
      map = componentValueStore(
        clientComponents.Map,
        torii.poseidonHash([BigInt($sessionData.map_id).toString()])
      )
  })

  run(() => {
    gameState.set($sessionData.state)
  })
  run(() => {
    console.log($isMoveRecorded)
  })

  // Some logs to see what's going on
  run(() => {
    console.log('session', $sessionData)
  })
  run(() => {
    console.log('sessionMeta', $sessionMetaData)
  })
  run(() => {
    console.log('sessionMeta bullets', $sessionMetaData.bullets)
  })

  run(() => {
    if ($sessionData.state === 3) {
      isEnded.set(true)
    }
  })

  run(() => {
    if ($sessionMetaData) {
      turnCount.set($sessionMetaData.turn_count)
    }
  })

  run(() => {
    if ($sessionMetaData) {
      sessionMetaData.subscribe((data) => {
        if ($account) {
          console.log('sessionData player1', $sessionData.player1.toString())
          console.log('sessionData player2', $sessionData.player2.toString())
          console.log('account', $account?.address)
          let isFirstPlayer = areAddressesEqual(
            $sessionData.player1.toString(),
            $account?.address
          )
          let isSecondPlayer = areAddressesEqual(
            $sessionData.player2.toString(),
            $account?.address
          )

          if (isFirstPlayer) {
            currentPlayerId.set(1)
          } else if (isSecondPlayer) {
            currentPlayerId.set(2)
          } else {
            currentPlayerId.set(null)
          }
          console.log('currentPlayerId', $currentPlayerId)
        }
      })
    }
  })

  run(() => {
    if ($sessionMetaData) {
      sessionMetaData.subscribe((data) => {
        isTurn =
          //is player 1 and it's 1s turn
          ($currentPlayerId === 1 && data.turn_count % 2 === 0) ||
          //is player 2 and it's 2s turn
          ($currentPlayerId === 2 && data.turn_count % 2 === 1)
        isTurnPlayer.set(isTurn)
      })
    }
  })

  run(() => {
    if ($sessionMetaData) {
      characterIds.set([
        $sessionMetaData.p1_character,
        $sessionMetaData.p2_character,
      ])
      if (map) {
        console.log('map', $map)
        mapObjects.set({
          grid1: get(map).grid1,
          grid2: get(map).grid2,
          grid3: get(map).grid3,
        })
      }
    }
  })

  run(() => {
    if ($sessionMetaData.bullets) {
      bulletStart.set([])
      bulletRender.set([])
      bulletInitialPosition.set([]) // Reset the initial position store
      bulletInitialPositionOnchain.set([]) // Reset the onchain initial position store
      bulletRenderOnchain.set([]) // Reset the onchain render position store
      $sessionMetaData.bullets.forEach((bulletId) => {
        let turn_count = $sessionMetaData.turn_count
        //@ts-ignore Only gives error bc torii gives primtive types and ts thinks it's a number
        let bulletEntity = torii.poseidonHash([
          BigInt(bulletId.value).toString(),
        ])
        let bulletStore = componentValueStore(
          clientComponents.Bullet,
          bulletEntity
        )
        bulletStore.subscribe((bullet) => {
          console.log('bullet', bullet)
          if (!bullet) return
          let v = bullet.velocity
          let coords = getBulletPosition(
            bullet,
            turn_count * BULLET_SUBSTEPS * 100 - bullet.shot_step
          )

          //if bullet is outside map boundary, don't add it
          if (isOutsideMapBoundary(coords.x, coords.y)) {
            return
          }

          let x_dir = v.xdir ? 1 : -1
          let y_dir = v.ydir ? 1 : -1
          let velocity = { x: (x_dir * v.x) / 300, y: (y_dir * v.y) / 300 }

          //TODO, shot by is character id not address
          if (!$account) return
          let shot_by = areAddressesEqual(
            bullet.shot_by.toString(),
            $account?.address
          )
            ? 1
            : 2
          let data = {
            coords: coords,
            velocity: velocity,
            id: bullet.bullet_id,
            shot_by: shot_by,
          }
          setBulletCoords(data)
          bulletRenderOnchain.update((currentState) => [...currentState, data]) // Store render position in onchain store

          // Store the initial position
          let initialCoords = getBulletPosition(bullet, 0)
          console.log('initialCoords', initialCoords)
          let initialPosition = {
            coords: initialCoords,
            velocity: velocity,
            id: bullet.bullet_id,
            shot_by: shot_by,
          }
          setBulletInitialPosition(initialPosition)
          bulletInitialPositionOnchain.update((currentState) => [
            ...currentState,
            initialPosition,
          ]) // Store initial position in onchain store
        })
      })
    }
  })

  run(() => {
    if ($isMoveRecorded)
      calldata = {
        sub_moves: $recordedMove.sub_moves,
        shots: $recordedMove.shots,
      }
  })
  // Extract character data w/ characterIds
  run(() => {
    if ($characterIds) {
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
            if ($characterData && $account) {
              let isPlayer = areAddressesEqual(
                $characterData.player_id,
                $account?.address
              )
              if (isPlayer) {
                playerStartCoords.set({ [position.id]: position.coords })
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
  })

  onMount(async () => {
    if ($env === 'mainnet') {
      if (await controllerMainnet.probe()) {
        // auto connect
        await connect('mainnet')
      }
    } else {
      if (await controllerSlot.probe()) {
        // auto connect
        await connect('slot')
      }
    }
  })
</script>

{#await gameStorePromise}
  <p>Game is loading...</p>
{:then gameStore}
  <GameComponent {gameStore} />
{/await}
