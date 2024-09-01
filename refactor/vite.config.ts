import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import wasm from 'vite-plugin-wasm';
import topLevelAwait from 'vite-plugin-top-level-await';

export default defineConfig({
  plugins: [
    sveltekit(),
    wasm(),
    topLevelAwait()
  ],
  build: {
    sourcemap: false, 
  },
  server: {
    host: 'localhost',
    port: 3000,
  },
  resolve: {
    alias: {
    }
  },
  ssr: {
    noExternal: ['@dojoengine/torii-client'],
  }
});
