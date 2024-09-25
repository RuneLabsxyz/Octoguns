import manifest from '../../contracts/manifests/dev/deployment/manifest.json'

import { createDojoConfig } from '@dojoengine/core'

export const dojoConfig = createDojoConfig({
  manifest,
  toriiUrl: 'http://localhost:8080',
})

export type Config = typeof dojoConfig
