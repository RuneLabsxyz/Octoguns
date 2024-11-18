import { writable, derived } from 'svelte/store';

export const env = writable<'mainnet' | 'sepolia' | 'slot'>('slot');

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

export const SEPOLIA = {
    PUBLIC_TORII_URL: 'https://api.cartridge.gg/planetelo/torii',   
    PUBLIC_RPC_URL: 'https://api.cartridge.gg/starknet/sepolia',       
    PUBLIC_WORLD_ADDRESS: import.meta.env.VITE_SEPOLIA_PUBLIC_WORLD_ADDRESS, 
    ENV: 'sepolia'
};

export interface Config {
    PUBLIC_TORII_URL: string;
    PUBLIC_RPC_URL: string;
    PUBLIC_WORLD_ADDRESS: string;
    ENV: 'mainnet' | 'slot' | 'sepolia';
}

export const CONFIG = derived(env, $env => ($env === 'mainnet' ? MAINNET : $env === 'sepolia' ? SEPOLIA : SLOT));
