<script lang="ts">
  import { gameState, sessionId, currentPlayerId } from '$stores/gameStores'
  import { dojoStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { get } from 'svelte/store'
  import SettingUp from './ingame/SettingUp.svelte'

  $: ({ clientComponents, torii, burnerManager, client } = $dojoStore)

  $: account = burnerManager.getActiveAccount()

  function spawn() {
    if (account) {
      client.spawn.spawn({ account: account, session_id: $sessionId })
    }
  }

  // On mount, if the game state is equals to 1 and you are the new player that just joined (player 2), spawn the characters.
  $: if ($gameState === 1 && $currentPlayerId === 2) {
    console.log('Spawning characters')
    spawn()
  }
</script>

{#if $gameState == 1}
  <SettingUp />
{/if}
