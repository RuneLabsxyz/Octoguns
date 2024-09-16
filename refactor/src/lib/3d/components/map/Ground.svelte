<script lang="ts">
  import { T } from '@threlte/core'
  import { FakeGlowMaterial } from '@threlte/extras'
  import { Edges } from '@threlte/extras'
  import { Color } from 'three'

  const monochromeColors = [
    0xffffff, 0xf0f0f0, 0xe0e0e0, 0xd0d0d0, 0xc0c0c0, 0xb0b0b0, 0xa0a0a0,
    0x909090, 0x808080, 0x707070, 0x606060, 0x505050, 0x404040, 0x303030,
    0x202020, 0x101010,
  ]

  function seededRandom(seed: number) {
    const x = Math.sin(seed) * 10000
    return x - Math.floor(x)
  }

  function getColor(i: number, j: number): Color {
    const seed = i * 1000 + j
    const randomIndex = Math.floor(seededRandom(seed) * monochromeColors.length)
    return new Color(monochromeColors[randomIndex])
  }
</script>

{#each Array(20).fill(0) as _, i}
  {#each Array(20).fill(0) as _, j}
    <T.Mesh receiveShadow position={[i * 5 - 47.5, -0.5, j * 5 - 47.5]}>
      <FakeGlowMaterial glowColor="blue" />
      <T.BoxGeometry args={[5, 1, 5]} />
      <T.MeshBasicMaterial
        color={getColor(i, j)}
        roughness={2.05}
        metalness={0.9}
        envMapIntensity={0.5}
      />
      <Edges color="white" />
    </T.Mesh>
  {/each}
{/each}
