import { writable, derived } from 'svelte/store';

export const env = writable<'mainnet' | 'slot'>('slot');

export const MAINNET = {
    PUBLIC_TORII_URL: 'https://api.cartridge.gg/x/octoguns-mn-alpha-1/torii',
    PUBLIC_RPC_URL: 'https://api.cartridge.gg/x/starknet/mainnet',
    PUBLIC_WORLD_ADDRESS: '0x7447477a7c852c946f0b8d13ebdfe0db9e78f3de60ab799320691502b4d32a3',
    ENV: 'mainnet'
};

export const SLOT = {
    PUBLIC_TORII_URL: 'https://api.cartridge.gg/x/octoguns-alpha1/torii',
    PUBLIC_RPC_URL: 'https://api.cartridge.gg/x/octoguns-alpha1/katana',
    PUBLIC_WORLD_ADDRESS: '0x7447477a7c852c946f0b8d13ebdfe0db9e78f3de60ab799320691502b4d32a3',
    ENV: 'slot'
};

export interface Config {
    PUBLIC_TORII_URL: string;
    PUBLIC_RPC_URL: string;
    PUBLIC_WORLD_ADDRESS: string;
    ENV: 'mainnet' | 'slot';
}

export const CONFIG = derived(env, $env => ($env === 'mainnet' ? MAINNET : SLOT));
