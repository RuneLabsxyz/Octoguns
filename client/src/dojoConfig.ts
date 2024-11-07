import { get } from 'svelte/store'
import manifest from '$manifests/deployment/manifest.json'
import { createDojoConfig } from '@dojoengine/core'
import { CONFIG } from '$stores/network'

export const dojoConfig = createDojoConfig({
  toriiUrl: 'http://127.0.0.1/8080',
  rpcUrl: 'http://127.0.0.1/5050',
  manifest,
})

export type Config = typeof dojoConfig
