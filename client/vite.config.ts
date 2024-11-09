import { sveltekit } from '@sveltejs/kit/vite'
import { defineConfig } from 'vite'
import { env } from 'node:process'
import wasm from 'vite-plugin-wasm'
import topLevelAwait from 'vite-plugin-top-level-await'
import faroUploader from '@grafana/faro-rollup-plugin';

export default defineConfig({
  plugins: [
    sveltekit(),
    wasm(),
    topLevelAwait(),
    faroUploader({
      appName: 'octoguns',
      endpoint: 'https://faro-api-prod-eu-west-2.grafana.net/faro/api/v1',
      appId: '1531',
      stackId: '1068348',
      apiKey: env.GRAFANA_API_KEY!,
      gzipContents: true,
    })
  ],
  build: {
    sourcemap: false,
    minify: false,
  },
  server: {
    host: 'localhost',
    port: 3000,
  },
  resolve: {
    alias: {},
  },
  ssr: {
    noExternal: ['@dojoengine/torii-client'],
  },
})
