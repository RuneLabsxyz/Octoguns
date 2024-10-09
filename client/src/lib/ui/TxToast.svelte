<script>
  import { fade } from 'svelte/transition';
  import { onMount } from 'svelte';

  export let message = '';
  export let status = 'loading'; // 'loading', 'success', or 'error'
  export let duration = 3000; // Duration in milliseconds

  let visible = true;

  onMount(() => {
    if (status !== 'loading') {
      const timer = setTimeout(() => {
        visible = false;
      }, duration);
      return () => clearTimeout(timer);
    }
  });
</script>

{#if visible}
  <div class="toast" transition:fade={{ duration: 300 }}>
    <div class="icon">
      {#if status === 'loading'}
        <div class="loading-circle"></div>
      {:else if status === 'success'}
        <svg class="checkmark" viewBox="0 0 24 24">
          <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z" />
        </svg>
      {:else if status === 'error'}
        <svg class="cross" viewBox="0 0 24 24">
          <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41z" />
        </svg>
      {/if}
    </div>
    <p>{message}</p>
  </div>
{/if}

<style>
  .toast {
    position: fixed;
    top: 20px;
    right: 20px;
    background-color: #333;
    color: white;
    padding: 12px 20px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    z-index: 1000;
  }

  .icon {
    margin-right: 12px;
    width: 24px;
    height: 24px;
  }

  .loading-circle {
    border: 2px solid #f3f3f3;
    border-top: 2px solid #3498db;
    border-radius: 50%;
    width: 20px;
    height: 20px;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  .checkmark, .cross {
    fill: currentColor;
  }

  .checkmark {
    color: #4CAF50;
  }

  .cross {
    color: #F44336;
  }

  p {
    margin: 0;
  }
</style>

