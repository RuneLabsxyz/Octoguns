<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { onMount } from 'svelte'
  import { get } from 'svelte/store'

  import SettingUp from './ingame/SettingUp.svelte'
  import { account } from '$stores/account'
  import getGame from '$lib/api/svelte/context'

  const { session, currentPlayerId, spawn } = getGame()

  const sessionState: number | undefined = $derived(Number($session?.state))

  $effect(() => {
    if (sessionState === 1 && $currentPlayerId === 2 && $account) {
      spawn()
    }
  })
</script>

{#if sessionState === 1}
  <SettingUp />
{/if}
