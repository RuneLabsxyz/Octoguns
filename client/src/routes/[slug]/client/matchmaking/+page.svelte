<script lang="ts">
    import { dojoStore } from '$stores/dojoStore'
    import { componentValueStore, type ComponentStore } from '$dojo/componentValueStore'
    import { goto } from '$app/navigation'
    import { type Entity, getComponentValue } from '@dojoengine/recs'
    import MiniMap from '$lib/MiniMap.svelte'
    import Button from '$lib/ui/Button.svelte'
    import TxToast from '$lib/ui/TxToast.svelte'
    import { cn } from '$lib/css/cn'
    import { account  } from '$stores/account'
    import { env } from '$stores/network';
    import { planeteloStore } from '$stores/dojoStore';
    import { get } from 'svelte/store';
    import { AccountInterface, type Call } from 'starknet';
  
    let playerEntity: Entity
    let mapCount: number = 0
    let clientComponents: any
    let torii: any
    let globalentity: any
    let global: ComponentStore
  
    $: if ($dojoStore) ({ clientComponents, torii } = $dojoStore as any)
  
    $: if (torii) globalentity = torii.poseidonHash([BigInt(0).toString()])
  
    $: if ($account && torii) playerEntity = torii.poseidonHash([$account?.address])
  
    $: if (clientComponents) global = componentValueStore(clientComponents.Global, globalentity)

  
    async function getStatus() {
      let planetelo: any = get(planeteloStore);
      console.log(planetelo)
      planetelo.connect($account!)
      console.log(await planetelo.get_status($account!.address, '0x6f63746f67756e73', '0x0'))
    }

    async function queue() {
      let planetelo: any = get(planeteloStore);
      planetelo.connect($account!)
      console.log($account);
      let signer: AccountInterface = $account!;
      let res = await signer.execute([{
        contractAddress: planetelo.address,
        entrypoint: "queue",
        calldata: ['0x6f63746f67756e73', '0x0']
      }])
      console.log(res)

      //await $account?.execute(call)
    }
 
    async function createMap() {
      goto(`/${$env}/client/mapmaker`)
    }
  
  </script>
  
  <div class={cn('flex flex-col h-full')}>
    <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
      <Button on:click={() => {
        queue()
      }}>Queue</Button>
    </div>

    <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
      <Button on:click={() => {
        getStatus()
      }}>Get Status</Button>
    </div>
</div>

  
  
  <style>
    .grid-fill {
      grid-template-columns: repeat(auto-fill, 330px);
    }
  
    .map-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 16px;
      padding: 16px;
    }
  
    .flex {
      display: flex;
    }
  
    .justify-between {
      justify-content: space-between;
    }
  
    .p-4 {
      padding: 1rem;
    }
  
    .fixed {
      position: fixed;
    }
  
    .bottom-0 {
      bottom: 0;
    }
  
    .left-0 {
      left: 0;
    }
  
    .right-0 {
      right: 0;
    }
  </style>
  