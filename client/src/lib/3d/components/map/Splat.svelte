<script lang="ts">
  import { run } from 'svelte/legacy';

  import { splat } from '$stores/eyeCandy'


  function triggerParticleExplosion(coords: { x: number; y: number }) {
    console.log('Particle explosion at:', coords)
    // TODO - Implement particle explosion
  }
  // Reactive statement to listen for changes in splat
  run(() => {
    if ($splat) {
      triggerParticleExplosion($splat[$splat.length - 1])
    }
  });
</script>
