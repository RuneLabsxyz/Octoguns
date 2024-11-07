<script lang="ts">
  import { run } from 'svelte/legacy';

  import { gameState, sessionId, currentPlayerId } from '$stores/gameStores'
  import { dojoStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { get } from 'svelte/store'
  import SettingUp from './ingame/SettingUp.svelte'
  import { account } from '$stores/account'

  let { clientComponents, torii, client } = $derived($dojoStore as any)



  async function spawn() {
    if ($account) {
      console.log('Spawn')
      await client.spawn.spawn({ account: $account, session_id: $sessionId })
    }
  }

  run(() => {
    if ($gameState === 1 && $currentPlayerId === 2 && $account) {
      console.log('Spawning characters')
      spawn()
    }
  });

</script>

{#if $gameState == 1}
  <SettingUp />
{/if}
