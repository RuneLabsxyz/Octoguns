import Controller from '@cartridge/controller';
import { account, username } from '$stores/account';

export const mapmakerContract = '0x11e7a657668ca83c556f7545ab5bde00c1a1275c6c9ed17bea33104fcda2f3b'
export const spawnContract = '0x57a72dd6f0bf3b0ced0fd50e54696643b8e3b38e226a150a1471c658355921e'
export const startContract = '0x44ce069fe53c5c7941eec521bc9e876907d5da6ca273a98b78f1cbbcfea5b62'
export const actionsContract = '0x11de1871e7fa8ac97e62c36724c32ee584982f4a5892b4f62fd545d7ab2d506'

export const planeteloContract = '0x70477df9a612d0193aa8084e8b0f734c1915ae9c35ae860e2d5adc89b961b2c'

export const controllerMainnet = new Controller({
  rpc: "https://api.cartridge.gg/x/starknet/mainnet"
})

export const controllerSlot = new Controller({
  rpc: "https://api.cartridge.gg/x/octoguns-alpha2/katana"
})


export const controllerSepolia = new Controller({
  rpc: "https://api.cartridge.gg/x/starknet/sepolia",
  policies: [
    {
        target: planeteloContract,
        method: "queue",
    },
    {
        target: planeteloContract,
        method: "matchmake",
    },
    {
        target: planeteloContract,
        method: "settle",
    },
    {
        target: actionsContract,
        method: "move",
    }

    // ... other policies
],
})

export async function connect(network: string) {
    try {
      if (network === "mainnet") {
        console.log("Connecting to mainnet");
        const res = await controllerMainnet.connect();
        if (res) {
            account.set(controllerMainnet.account);
            username.set(await controllerMainnet.username());
        }      
      } else if (network === "sepolia") {
        console.log("Connecting to sepolia");
        const res = await controllerSepolia.connect();
        if (res) {
            account.set(controllerSepolia.account);
            username.set(await controllerSepolia.username());
        }
      } else {
        console.log("Connecting to local network");
        const res = await controllerSlot.connect();
        if (res) {
            console.log(res)
            account.set(controllerSlot.account);
            username.set(await controllerSlot.username());
        }
      }
    } catch (e) {
        console.log(e);
    }
}

export async function disconnect() {
  await controllerMainnet.disconnect();
  await controllerSepolia.disconnect();
  await controllerSlot.disconnect();
  account.set(undefined);
  username.set(undefined);
}
