<script lang="ts">
    import { dojoStore } from '$stores/dojoStore'
    import { componentValueStore, type ComponentStore } from '$dojo/componentValueStore'
    import { goto } from '$app/navigation'
    import { type Entity, getComponentValue } from '@dojoengine/recs'
    import MiniMap from '$lib/MiniMap.svelte'
    import TxToast from '$lib/ui/TxToast.svelte'
    import { cn } from '$lib/css/cn'
    import { account  } from '$stores/account'
    import { env } from '$stores/network';
    import { planeteloStore } from '$stores/dojoStore';
    import { get } from 'svelte/store';
    import { AccountInterface, type Call } from 'starknet';
    import { onMount } from 'svelte';
    import { DojoProvider } from '@dojoengine/core';
    import { connect } from '$lib/controller'
    import { Contract } from 'starknet';

    let status: number;
    let elo: number;
    let queue_length: number;
    let game_id: number;
    let winner: number = 0;
    let intervalId: any;

    let planetelo: any = get(planeteloStore);
    let {config, dojoProvider}: any = get(dojoStore);
    console.log(config)

    const actions = new Contract(config.manifest.contracts[4].abi, config.manifest.contracts[4].address, dojoProvider.provider).typedv2(config.manifest.contracts[4].abi);

    async function handleQueue() {
        console.log(planetelo.address);
        let res = await $account?.execute(
            [{
                contractAddress: planetelo.address,
                entrypoint: 'queue',
                calldata: ["0x6f63746f67756e75", "0x0"]
            }]
        );
        console.log(res);
    }

    async function handleMatchmake() {
        console.log(planetelo.address);
        let res = await $account?.execute(
            [{
                contractAddress: planetelo.address,
                entrypoint: 'matchmake',
                calldata: ["0x6f63746f67756e75", "0x0"]
            }]
        );
        console.log(res);
    }

    $: buttonText = status === 0 ? 'Queue' 
                  : status === 1 ? 'Matchmake' 
                  : 'Play';

    $: buttonClass = status === 0 ? '' 
                  : status === 1 ? 'queuing'
                  : 'playing';

    async function handleSettle() {
        let res = await $account?.execute(
            [{
                contractAddress: planetelo.address,
                entrypoint: 'settle',
                calldata: ["0x6f63746f67756e75", game_id!]
            }]
        );
        console.log(res);
    }


    const get_status = async () => {
        status = parseInt(await planetelo.get_status($account!.address, "0x6f63746f67756e75", "0x0"));
        elo = await planetelo.get_elo($account!.address, "0x6f63746f67756e75", "0x0");
        console.log(elo)
        queue_length = parseInt(await planetelo.get_queue_length("0x6f63746f67756e75", "0x0"));
        if (status == 2) {
            game_id = parseInt(await planetelo.get_player_game_id($account!.address, "0x6f63746f67756e75", "0x0"));
            console.log(actions)
        }
        console.log(status)
    }

    onMount(() => {
        if (!$account) {
            connect('sepolia');
        }
        get_status();
        // Poll status every 2 seconds
        intervalId = setInterval(get_status, 2000);

        // Cleanup interval on component destroy
        return () => {
            clearInterval(intervalId);
        };
    });
</script>

{#if $dojoStore}
        <div class="queue-container">
            <div class="stats">
                <p>ELO: {elo}</p>
                <p>Players in Queue: {queue_length}</p>
            </div>
            {#if status === 2}
                    <div class="winner-container">
                        <p class="winner-text">Game Over!</p>
                        <button 
                            class="queue-button settle" 
                            on:click={handleSettle}
                        >
                            Settle
                        </button>
                    </div>
                    <div class="guess-container">
                      <p>In Game</p>
                        <button 
                            class="queue-button playing" 
                            on:click={() => goto(`/sepolia/game/${game_id}`)}
                        >
                            Go To Game
                        </button>
                    </div>
            {:else}
                <button 
                    class="queue-button {buttonClass}" 
                    on:click={status == 0 ? handleQueue : handleMatchmake}
                >
                    {buttonText}
                </button>
            {/if}
            {#if status === 1}
                <p class="status">Finding a match...</p>
            {/if}
        </div>
    {:else}
        <p>Setting up...</p>
    {/if}
  
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

    .queue-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 2rem;
        padding: 2rem;
        max-width: 600px;
        margin: 0 auto;
    }

    .stats {
        display: flex;
        gap: 2rem;
        font-size: 1.2rem;
        font-weight: 500;
    }

    .queue-button {
        padding: 1rem 2rem;
        font-size: 1.2rem;
        font-weight: 600;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        transition: all 0.2s ease;
        background-color: #4CAF50;
        color: white;
    }

    .queue-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .queue-button.queuing {
        background-color: #FFA500;
    }

    .queue-button.playing {
        background-color: #2196F3;
    }

    .queue-button.settle {
        background-color: #9C27B0;
    }
  </style>
  