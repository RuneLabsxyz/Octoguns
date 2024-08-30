<script lang="ts">
    import Ui from '$lib/ui/Ui.svelte';
    import Canvas from '$lib/3d/canvas.svelte';
</script>

<div class="absolute h-full w-full z-10">
    <Ui />  
</div>
<div class="absolute h-full w-full">
    <Canvas />
</div>