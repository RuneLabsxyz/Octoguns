<script lang="ts">
    import { dojoStore } from '$stores/dojoStore'
    import { componentValueStore } from '$dojo/componentValueStore'
    import { type Entity } from '@dojoengine/recs'
    import { account } from '$stores/account'
    import { username } from '$stores/account';
    import { goto } from '$app/navigation';
    import { env } from '$stores/network';


    let playerEntity: Entity
  
    $: ({ clientComponents, torii, client } = $dojoStore as any)  
    $: if ($account) playerEntity = torii.poseidonHash([$account?.address])

    $: player = componentValueStore(clientComponents.Player, playerEntity)

    $: console.log('player', $player)


    $: {
        if (!$player) {
            (async () => {
                console.log('creating account')
                await client.account.create_account({account: $account, player_name: $username});
                // goto(`/${$env}/client/games/openGames`);
            })();
        } else if ($player) {
            // goto(`/${$env}/client/games/openGames`);
        }
    }


  </script>