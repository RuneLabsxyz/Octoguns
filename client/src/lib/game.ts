import { dojoStore } from '$stores/dojoStore'
import { get } from 'svelte/store'
import { account } from '$stores/account'
import { env } from '$stores/network';

export async function joinSession(session: any) {
  let {  client } = get(dojoStore) as any

  if (get(account)) {
    console.log('Joining session', session.value)
    await client.start.join({ account: get(account), session_id: session.value })
    window.location.href = `${get(env)}/game/${session.value}`
  } else {
    console.error('No active account found')
  }
}

export async function goToSession(session: any) {
  console.log('session', session)
  window.location.href = `/${get(env)}/game/${session.value}`
}
