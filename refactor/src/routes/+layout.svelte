<script lang="ts">
    import "../app.css";
    import { onMount } from "svelte";
    import { initializeStore } from '../stores/dojoStore';    
    
    onMount(() => {
        try {
            initializeStore();
        } catch (error) {
            console.error('Failed to initialize store:', error);
        }
    });
</script>

<slot />
