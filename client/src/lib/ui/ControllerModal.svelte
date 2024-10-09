<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { goto } from '$app/navigation';
  import { username, account, clearAccountStorage } from '$stores/account';
  import Button from '$lib/ui/Button.svelte';

  export let show = false;
  const dispatch = createEventDispatcher();

  function closeModal() {
    dispatch('close');
  }

  function logout() {
    clearAccountStorage();
    closeModal();
    goto('/');
  }

  let showCopied = false;

  function compressAddress(address: string): string {
    if (!address) return 'Not available';
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  }

  function copyAddress() {
    if ($account && $account.address) {
      navigator.clipboard.writeText($account.address)
        .then(() => {
          showCopied = true;
          setTimeout(() => showCopied = false, 2000);
        })
        .catch(err => console.error('Failed to copy: ', err));
    }
  }
</script>

{#if show && $account && $username}
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white border-4 border-black rounded-lg p-6 w-11/12 max-w-md">
      <div class="flex items-center mb-4">
        <img src="/logos/controller/controller.png" alt="Controller" class="w-12 h-12 mx-auto" />
      </div>
      <div class="mb-4 space-y-4">
        <div class="flex flex-col items-center space-y-2">
          <p class="font-bold text-lg">{$username.toUpperCase()}</p>
          <div class="flex items-center">
            <span class="break-all">{compressAddress($account?.address)}</span>
            <button 
              on:click={copyAddress}
              class="ml-2 px-2 py-1 bg-gray-200 hover:bg-gray-300 rounded text-sm"
            >
              Copy
            </button>
          </div>
          {#if $account?.address && showCopied}
            <span class="text-green-600 text-sm">Copied!</span>
          {/if}
          <p class="text-sm text-center mt-2">
            Top up some STARK on this address to start playing!
          </p>
        </div>
        <slot></slot>
      </div>
      <div class="flex justify-between">
        <Button on:click={logout}>Logout</Button>
        <Button on:click={closeModal}>Close</Button>
      </div>
    </div>
  </div>
{/if}
