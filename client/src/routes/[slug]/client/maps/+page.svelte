<script lang="ts">
  import { dojoStore } from '$stores/dojoStore'
  import { componentValueStore } from '$dojo/componentValueStore'
  import { selectedMap } from '$stores/clientStores'
  import { goto } from '$app/navigation'
  import { type Entity, getComponentValue } from '@dojoengine/recs'
  import MiniMap from '$lib/MiniMap.svelte'
  import Button from '$lib/ui/Button.svelte'
  import TxToast from '$lib/ui/TxToast.svelte'
  import { cn } from '$lib/css/cn'
  import { env } from '$stores/network'
  import { maps as getMaps } from '$lib/api/maps'
  import type { Map } from '$src/dojo/models.gen'

  let maps: Map[] | null = $state([])

  getMaps.subscribe((mapsValue) => {
    if (mapsValue) {
      maps = mapsValue
    }
  })

  async function createMap() {
    goto(`/${$env}/client/mapmaker`)
  }
</script>

<div class={cn('flex flex-col h-full')}>
  <div class="flex p-5 py-2 mb-4 items-center border-b-4 border-black">
    <h1 class="text-3xl font-bold">Available maps</h1>
    <span class="flex-grow"></span>
    <Button on:click={createMap}>Create new map</Button>
  </div>

  <div
    class="grid grid-fill justify-around auto-cols-min px-3 overflow-auto overflow-x-hidden"
  >
    {#if maps}
      {#each maps as map}
        {#if map}
          <Button className="w-fit h-fit">
            <MiniMap {map} />
          </Button>
        {/if}
      {/each}
    {/if}
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
