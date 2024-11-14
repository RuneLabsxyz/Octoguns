<script lang="ts">
  import { splat } from '$stores/eyeCandy'

  // Reactive statement to listen for changes in splat
  $: if ($splat) {
    triggerParticleExplosion($splat[$splat.length - 1])
  }

  function triggerParticleExplosion(coords: { x: number; y: number }) {
    console.log('Particle explosion at:', coords)
    // TODO - Implement particle explosion
  }
</script>
