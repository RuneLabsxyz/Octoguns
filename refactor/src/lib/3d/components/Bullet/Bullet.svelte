<script lang="ts">
  import { T } from '@threlte/core'
  import { onMount } from 'svelte'
  import type { BulletCoords } from '$stores/coordsStores'
  import type { BufferGeometry, Points } from 'three'
  import { Color, Vector3 } from 'three'

  export let bullet: BulletCoords
  export let initialPosition: BulletCoords | undefined
  export let trailSpacing: number = 0.01
  export let compressionFactor: number = 1

  let geometry: BufferGeometry | undefined
  let pointsRef: Points | undefined

  $: x = bullet.coords.x
  $: y = bullet.coords.y

  $: initialX = initialPosition?.coords.x ?? x
  $: initialY = initialPosition?.coords.y ?? y

  $: length = Math.sqrt((x - initialX) ** 2 + (y - initialY) ** 2)
  $: count = Math.floor(length / trailSpacing)

  // Calculate direction vector
  $: direction = new Vector3(x - initialX, 0, y - initialY).normalize()

  // Function to generate random red shades
  function getRandomRedShade() {
    const red = 255
    const green = Math.floor(Math.random() * 100)
    const blue = Math.floor(Math.random() * 100)
    return new Color(red / 255, green / 255, blue / 255)
  }

  $: positions = (() => {
    const posArray = new Float32Array(count * 3)
    const colorArray = new Float32Array(count * 3)
    for (let i = 0; i < count; i++) {
      const t = i / (count - 1)
      const compressedT = Math.pow(t, compressionFactor)
      const px = initialX + (x - initialX) * compressedT
      const py = initialY + (y - initialY) * compressedT

      const randomFactor = 0.1
      const vx = px + (Math.random() - 0.5) * randomFactor
      const vy = 1 + (Math.random() - 0.5) * randomFactor
      const vz = py + (Math.random() - 0.5) * randomFactor

      posArray[i * 3 + 0] = vx // x
      posArray[i * 3 + 1] = vy // y
      posArray[i * 3 + 2] = vz // z

      const color = getRandomRedShade()
      colorArray[i * 3 + 0] = color.r
      colorArray[i * 3 + 1] = color.g
      colorArray[i * 3 + 2] = color.b
    }
    return { positions: posArray, colors: colorArray }
  })()

  $: if (geometry && positions) {
    geometry.attributes.position.needsUpdate = true
    geometry.computeBoundingSphere()

    if (geometry.boundingSphere) {
      const radius =
        Math.max(Math.abs(x - initialX), Math.abs(y - initialY), 1) * 2
      geometry.boundingSphere.radius = radius
      geometry.boundingSphere.center.set(
        (x + initialX) / 2,
        1,
        (y + initialY) / 2
      )
    }
  }

  onMount(() => {
    if (pointsRef) {
      pointsRef.frustumCulled = false
    }
  })
</script>

<T.Group>
  <!-- Bullet trail -->
  <T.Points bind:ref={pointsRef}>
    <T.BufferGeometry bind:geometry>
      <T.BufferAttribute
        args={[positions.positions, 3]}
        attach={(parent, self) => {
          parent.setAttribute('position', self)
        }}
      />
      <T.BufferAttribute
        args={[positions.colors, 3]}
        attach={(parent, self) => {
          parent.setAttribute('color', self)
        }}
      />
    </T.BufferGeometry>
    <T.PointsMaterial size={0.05} vertexColors />
  </T.Points>

  <!-- Current bullet position -->
  <T.Group
    position={[x, 1, y]}
    rotation={[
      Math.PI / 2,
      0,
      Math.atan2(direction.z, direction.x) - Math.PI / 2,
    ]}
  >
    <!-- Bullet body (cylinder) -->
    <T.Mesh position={[0, -0.15, 0]}>
      <T.CylinderGeometry args={[0.1, 0.1, 0.3, 16]} />
      <T.MeshStandardMaterial color="gray" />
    </T.Mesh>
    <!-- Bullet tip (cone) -->
    <T.Mesh position={[0, 0.1, 0]}>
      <T.ConeGeometry args={[0.1, 0.2, 16]} />
      <T.MeshStandardMaterial color="darkgray" />
    </T.Mesh>
  </T.Group>
</T.Group>
