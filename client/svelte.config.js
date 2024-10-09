import adapter from '@sveltejs/adapter-auto'
import dotenv from 'dotenv'
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

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
  },
  preprocess: vitePreprocess(),
}
export default config
