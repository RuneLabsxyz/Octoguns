import { dojoStore } from '$stores/dojoStore'
import { get } from 'svelte/store'

export async function joinSession(session: any) {
  let { burnerManager, client } = get(dojoStore)
  let account = burnerManager.getActiveAccount()

  if (account) {
    console.log('Joining session', session.value)
    await client.start.join({ account: account, session_id: session.value })
    window.location.href = `/game/${session.value}`
  } else {
    console.error('No active account found')
  }
}

export async function goToSession(session: any) {
  console.log('session', session)
  window.location.href = `/game/${session.value}`
}
