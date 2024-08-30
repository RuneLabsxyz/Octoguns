/** @type {import('tailwindcss').Config} */
// tailwind.config.js
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      fontFamily: {
        Block: ['Block', 'sans-serif'],
      },
    },
  },
  plugins: [],
};

