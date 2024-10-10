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

export const controller = new Controller({
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
  rpc: configValue.PUBLIC_RPC_URL
})



export async function connect() {
    try {
        const res = await controller.connect();
        if (res) {
            account.set(controller.account);
            username.set(await controller.username());
        }
    } catch (e) {
        console.log(e);
    }
}
