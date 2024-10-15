import { writable, derived } from 'svelte/store';

export const env = writable<'mainnet' | 'slot'>('slot');

export const MAINNET = {
    PUBLIC_TORII_URL: import.meta.env.VITE_MAINNET_PUBLIC_TORII_URL, 
    PUBLIC_RPC_URL: import.meta.env.VITE_MAINNET_PUBLIC_RPC_URL,     
    PUBLIC_WORLD_ADDRESS: import.meta.env.VITE_MAINNET_PUBLIC_WORLD_ADDRESS, 
    ENV: 'mainnet'
};

export const SLOT = {
    PUBLIC_TORII_URL: import.meta.env.VITE_SLOT_PUBLIC_TORII_URL,   
    PUBLIC_RPC_URL: import.meta.env.VITE_SLOT_PUBLIC_RPC_URL,       
    PUBLIC_WORLD_ADDRESS: import.meta.env.VITE_SLOT_PUBLIC_WORLD_ADDRESS, 
    ENV: 'slot'
};

export interface Config {
    PUBLIC_TORII_URL: string;
    PUBLIC_RPC_URL: string;
    PUBLIC_WORLD_ADDRESS: string;
    ENV: 'mainnet' | 'slot';
}

export const CONFIG = derived(env, $env => ($env === 'mainnet' ? MAINNET : SLOT));
