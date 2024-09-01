<script lang="ts">
    import "../app.css";
    import { onMount } from "svelte";
    import { initializeStore, isSetup } from '../stores/dojoStore';    
    
    onMount(() => {
        try {
            initializeStore();
            isSetup.set(true);
        } catch (error) {
            console.error('Failed to initialize store:', error);
            isSetup.set(false);
        }
    });
</script>

<slot />
