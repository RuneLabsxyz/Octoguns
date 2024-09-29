<script lang="ts">
  import { T } from '@threlte/core'
  import { mapObjects } from '$stores/gameStores'

  let coordsArray: { x: number; y: number }[] = []

  $: if ($mapObjects) {
    $mapObjects.objects.forEach((index) => {
      //@ts-ignore
      let i = index.value
      let x = (i % 25) * 4 + 2
      let y = Math.floor(i / 25) * 4 + 2
      coordsArray.push({ x: x, y: y })
    })
    console.log(coordsArray)
  }

  const vertexShader = `
      varying vec2 vUv;
      varying float vNoise;
  
      // Perlin noise function
      vec3 permute(vec3 x) {
        return mod(((x*34.0)+1.0)*x, 289.0);
      }
  
      float noise(vec2 v) {
        const vec4 C = vec4(0.211324865405187, 0.366025403784439,
                            -0.577350269189626, 0.024390243902439);
        vec2 i  = floor(v + dot(v, C.yy));
        vec2 x0 = v - i + dot(i, C.xx);
  
        vec2 i1;
        i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
        vec4 x12 = x0.xyxy + C.xxzz;
        x12.xy -= i1;
  
        i = mod(i, 289.0);
        vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
              + i.x + vec3(0.0, i1.x, 1.0));
  
        vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy),
                                dot(x12.zw, x12.zw)), 0.0);
        m = m * m;
        m = m * m;
  
        vec3 x = 2.0 * fract(p * C.www) - 1.0;
        vec3 h = abs(x) - 0.5;
        vec3 ox = floor(x + 0.5);
        vec3 a0 = x - ox;
  
        m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  
        vec3 g;
        g.x  = a0.x  * x0.x  + h.x  * x0.y;
        g.yz = a0.yz * x12.xz + h.yz * x12.yw;
        return 130.0 * dot(m, g);
      }
  
      void main() {
        vUv = uv;
  
        // Compute the noise value
        float n = noise(vUv * 10.0);
        vNoise = n;
  
        // Displace the position along the normal
        float displacementScale = 0.1; // Adjust this value as needed
        vec3 displacedPosition = position + normal * n * displacementScale;
  
        gl_Position = projectionMatrix * modelViewMatrix * vec4(displacedPosition, 1.0);
      }
    `

  const fragmentShader = `
      varying vec2 vUv;
      varying float vNoise;
  
      void main() {
        // Use the noise value for coloring and make it transparent
        gl_FragColor = vec4(vec3(vNoise * 0.4), 0.2); // Adjust the alpha value as needed
      }
    `
</script>

<T.Group>
  {#each coordsArray as coord}
    <T.Mesh position={[coord.x - 50, 2, coord.y - 50]}>
      <!-- Increase the segments here -->
      <T.BoxGeometry args={[4, 5, 4, 50, 50, 50]} />
      <T.ShaderMaterial
        {vertexShader}
        {fragmentShader}
        wireframe={false}
        transparent={true}
      />
    </T.Mesh>
  {/each}
</T.Group>
