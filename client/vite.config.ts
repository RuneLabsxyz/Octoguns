import { sveltekit } from '@sveltejs/kit/vite'
import { defineConfig } from 'vite'
import wasm from 'vite-plugin-wasm'
import topLevelAwait from 'vite-plugin-top-level-await'
import mkcert from 'vite-plugin-mkcert'

export default defineConfig({
  plugins: [sveltekit(), wasm(), topLevelAwait(), mkcert()],
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
