import Controller from '@cartridge/controller';
import { account, username } from '$stores/account';
import { goto } from '$app/navigation';
import { CONFIG } from '$stores/network'; 
import { get } from 'svelte/store';

const configValue = get(CONFIG);

export const mapmakerContract = '0x11e7a657668ca83c556f7545ab5bde00c1a1275c6c9ed17bea33104fcda2f3b'
export const spawnContract = '0x57a72dd6f0bf3b0ced0fd50e54696643b8e3b38e226a150a1471c658355921e'
export const startContract = '0x44ce069fe53c5c7941eec521bc9e876907d5da6ca273a98b78f1cbbcfea5b62'
export const actionsContract = '0x11de1871e7fa8ac97e62c36724c32ee584982f4a5892b4f62fd545d7ab2d506'

export const controllerMainnet = new Controller({
  policies: [
    {
      target: startContract,
      method: 'create'
    },
    {
      target: startContract,
      method: 'create_closed'
    },
    {
      target: startContract,
      method: 'join'
    },
    {
      target: mapmakerContract,
      method: 'create'
    },
    {
      target: actionsContract,
      method: 'move'
    },
    {
      target: spawnContract,
      method: 'spawn'
    }
  ],
  rpc: "https://api.cartridge.gg/x/starknet/mainnet"
})


export const controllerSlot = new Controller({
  policies: [
    {
      target: startContract,
      method: 'create'
    },
    {
      target: startContract,
      method: 'create_closed'
    },
    {
      target: startContract,
      method: 'join'
    },
    {
      target: mapmakerContract,
      method: 'create'
    },
    {
      target: actionsContract,
      method: 'move'
    },
    {
      target: spawnContract,
      method: 'spawn'
    }
  ],
  rpc: "https://api.cartridge.gg/x/octoguns-alpha1/katana"
})



export async function connect(network: string) {
    try {
      if (network === "mainnet") {
        const res = await controllerMainnet.connect();
        if (res) {
            account.set(controllerMainnet.account);
            username.set(await controllerMainnet.username());
        }      
      } else {
        const res = await controllerSlot.connect();
        if (res) {
            account.set(controllerSlot.account);
            username.set(await controllerSlot.username());
        }
      }
      

    } catch (e) {
        console.log(e);
    }
}
