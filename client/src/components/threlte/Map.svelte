<script lang="ts">
	import { T, useTask} from '@threlte/core'
	import { AutoColliders, CollisionGroups } from '@threlte/rapier'
	import { spring } from 'svelte/motion'
	import { BoxGeometry, Mesh, MeshStandardMaterial, Vector3 } from 'three'
	import Ground from './Ground.svelte'
	import { derived } from 'svelte/store'
	import { setupStore } from 'src/main'
	import { createComponentValueStore } from 'src/dojo/componentValueStore'
	import { current_session_id } from 'src/stores'
	import CharacterModel from './CharacterModel.svelte'
	import { isYourTurn, player_number, gameStarted } from 'src/stores'
	import Bullet from './Bullet.svelte'

	let entity: any;
	let session: any;
	let session_meta: any;


	$: ({ clientComponents, torii, burnerManager, client } = $setupStore);

	$: entity = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash([BigInt($current_session_id ? $current_session_id: 0).toString()])
		: undefined
	);

	$: if (current_session_id) session = createComponentValueStore(clientComponents.Session, entity);
	$: if (current_session_id) session_meta = createComponentValueStore(clientComponents.SessionMeta, entity);

	$: if ($session.state >= 2 ) gameStarted.set(true); 

	let playerMesh: Mesh
	let positionHasBeenSet = false
	const smoothPlayerPosX = spring(0)
	const smoothPlayerPosZ = spring(0)
	const t3 = new Vector3()
	useTask(() => {
	  if (!playerMesh) return
	  playerMesh.getWorldPosition(t3)
	  smoothPlayerPosX.set(t3.x, {
		hard: !positionHasBeenSet
	  })
	  smoothPlayerPosZ.set(t3.z, {
		hard: !positionHasBeenSet
	  })
	  if (!positionHasBeenSet) positionHasBeenSet = true
	})

	$: account = burnerManager.getActiveAccount();
	$: if ($session) {if (AddressToBigInt(account.address) == $session.player1) {
		player_number.set(1);
	} else {
		player_number.set(2);
	}}
	let users_turn;
	$: if(session_meta) users_turn = $session_meta.turn_count % 2
	$: if (users_turn + 1 == $player_number) {
		isYourTurn.set(true)
	}
	$: console.log($session_meta.characters)
	$: console.log($session)

    function AddressToBigInt(address: string): bigint {
        if (!address.startsWith('0x')) {
            address = '0x' + address;
        }
        return BigInt(address);
    }
  </script>


<T.DirectionalLight castShadow position={[3, 10, 10]} />
<T.AmbientLight intensity={0.2} />
  <Bullet />
	<CollisionGroups groups={[0, 15]}>
	<Ground />
  </CollisionGroups>
  <CollisionGroups groups={[0]}>
	<!-- <Character
	  bind:playerMesh
	  position={[0, 2, 3]}
	/> -->
	<AutoColliders shape={'cuboid'}>
	  <T.Mesh
		receiveShadow
		castShadow
		position.x={30 + 0.7 + 0.15}
		position.y={1.275}
		geometry={new BoxGeometry(60, 2.55, 0.15)}
		material={new MeshStandardMaterial({
		  transparent: true,
		  opacity: 0.5,
		  color: 0x333333
		})}
	  />
	  <T.Mesh
		receiveShadow
		castShadow
		position.x={-30 - 0.7 - 0.15}
		position.y={1.275}
		geometry={new BoxGeometry(60, 2.55, 0.15)}
		material={new MeshStandardMaterial({
		  transparent: true,
		  opacity: 0.5,
		  color: 0x333333
		})}
	  />
	</AutoColliders>
  </CollisionGroups>

  {#if $session_meta}
	{#each $session_meta.characters as character}
		<CharacterModel id={character.value} /> 
	{/each}
  {/if}
  
