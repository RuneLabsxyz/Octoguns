<script lang="ts">
  import { T } from '@threlte/core'
  import { FakeGlowMaterial } from '@threlte/extras'
  import { Edges } from '@threlte/extras'
</script>

{#each Array(20).fill(0) as _, i}
  {#each Array(20).fill(0) as _, j}
    <T.Mesh receiveShadow position={[i * 5 - 47.5, -0.5, j * 5 - 47.5]}>
      <FakeGlowMaterial glowColor="blue" />
      <T.BoxGeometry args={[5, 0.5, 5]} />

      <Edges color="white" />
    </T.Mesh>
  {/each}
{/each}
