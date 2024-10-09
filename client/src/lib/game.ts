import { dojoStore } from '$stores/dojoStore'
import { get } from 'svelte/store'
import { account } from '$stores/account'

export async function joinSession(session: any) {
  let {  client } = get(dojoStore)

  if (get(account)) {
    console.log('Joining session', session.value)
    await client.start.join({ account: get(account), session_id: session.value })
    window.location.href = `/game/${session.value}`
  } else {
    console.error('No active account found')
  }
}

export async function goToSession(session: any) {
  console.log('session', session)
  window.location.href = `/game/${session.value}`
}
