import adapter from '@sveltejs/adapter-auto'
import dotenv from 'dotenv'
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { env } from 'node:process';

const path = fileURLToPath(new URL('package.json', import.meta.url));
const pkg = JSON.parse(readFileSync(path, 'utf8'));

dotenv.config()

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter(),
    alias: {
      $lib: 'src/lib',
      $src: 'src',
      $stores: 'src/stores',
      $dojo: 'src/dojo',
      $manifests: `../contracts/manifests/${process.env.ENV}`
    },
    version: {
      name: pkg.version
    },
  },
  preprocess: vitePreprocess(),
}
export default config
