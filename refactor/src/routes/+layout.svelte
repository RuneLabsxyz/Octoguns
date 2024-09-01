<script lang="ts">
    export const ssr = false;
    export const prerender = false;


    import "../app.css";
    import { onMount } from "svelte";
    import { initializeStore } from '../stores/dojoStore';    
    
    onMount(() => {
        initializeStore();
    });
</script>

<slot />
