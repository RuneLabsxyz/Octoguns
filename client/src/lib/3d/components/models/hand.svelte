<!--
Auto-generated by: https://github.com/threlte/threlte/tree/main/packages/gltf
Command: npx @threlte/gltf@3.0.0-next.10 ./static/3d/hand.glb --transform -t
-->

<script lang="ts">
  import type * as THREE from 'three'

  import type { Snippet } from 'svelte'
  import { T, type Props } from '@threlte/core'
  import { useDraco, useGltf } from '@threlte/extras'

  let {
    fallback,
    error,
    children,
    ref = $bindable(),
    ...props
  }: Props<THREE.Group> & {
    ref?: THREE.Group
    children?: Snippet<[{ ref: THREE.Group }]>
    fallback?: Snippet
    error?: Snippet<[{ error: Error }]>
  } = $props()

  type GLTFResult = {
    nodes: {
      pasted__pCylinder1: THREE.Mesh
      pasted__pasted__pCylinder1: THREE.Mesh
      pasted__pPlane5: THREE.Mesh
      pasted__pasted__pPlane5: THREE.Mesh
      pasted__pPlane5001: THREE.Mesh
      pasted__pCylinder1001: THREE.Mesh
      pasted__pCylinder2: THREE.Mesh
      pasted__pPlane7: THREE.Mesh
      pPlane1: THREE.Mesh
      pPlane2: THREE.Mesh
      pPlane3: THREE.Mesh
      pPlane4: THREE.Mesh
      pPipe1: THREE.Mesh
      pPlane5: THREE.Mesh
      pPlane6: THREE.Mesh
      pCylinder1: THREE.Mesh
      pCylinder2: THREE.Mesh
      pPlane7: THREE.Mesh
      pPlane8: THREE.Mesh
      pPlane9: THREE.Mesh
      pPipe2: THREE.Mesh
      pCylinder3: THREE.Mesh
      pPipe3: THREE.Mesh
      pPlane10: THREE.Mesh
      pSphere1: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F5c: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F5b: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F5a: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F4c: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F4b: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F4a: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F3c: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F3b: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F3a: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F2c: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F2b: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F2a: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F1b: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_F1a: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_UA: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_H2: THREE.Mesh
      CSS_Arms_OBJ_Smoothed_H1: THREE.Mesh
    }
    materials: {
      lambert1: THREE.MeshStandardMaterial
      ['CSS_Arms_OBJ_Smoothed_:default2']: THREE.MeshStandardMaterial
    }
  }
  const dracoLoader = useDraco()
  const gltf = useGltf<GLTFResult>('/3d/hand-transformed.glb', {
    dracoLoader,
  })
</script>

<T.Group bind:ref dispose={false} {...props}>
  {#await gltf}
    {@render fallback?.()}
  {:then gltf}
    <T.Group rotation={[Math.PI / 2, 0, 0]} scale={0.01}>
      <T.Mesh
        geometry={gltf.nodes.pasted__pCylinder1.geometry}
        material={gltf.materials.lambert1}
        position={[-2.21, 10.11, -10]}
        rotation={[0, 0, 1.58]}
        scale={1.2}
      />
    </T.Group>
    <T.Group rotation={[Math.PI / 2, 0, 0]} scale={0.01}>
      <T.Mesh
        geometry={gltf.nodes.pasted__pasted__pCylinder1.geometry}
        material={gltf.materials.lambert1}
        position={[-2.21, 10.45, -10]}
        rotation={[0, 0, 1.58]}
      />
    </T.Group>
    <T.Group rotation={[Math.PI / 2, 0, 0]} scale={0.01}>
      <T.Mesh
        geometry={gltf.nodes.pasted__pPlane5.geometry}
        material={gltf.materials.lambert1}
        position={[-4.46, 0.8, -11.51]}
      />
    </T.Group>
    <T.Group rotation={[Math.PI / 2, 0, 0]} scale={0.01}>
      <T.Mesh
        geometry={gltf.nodes.pasted__pPlane5001.geometry}
        material={gltf.materials.lambert1}
        position={[0, 0.8, -10.48]}
      />
      <T.Mesh
        geometry={gltf.nodes.pasted__pCylinder1001.geometry}
        material={gltf.materials.lambert1}
        position={[0.07, 9.05, -8.51]}
      />
      <T.Mesh
        geometry={gltf.nodes.pasted__pCylinder2.geometry}
        material={gltf.materials.lambert1}
        position={[0.09, 4.89, -8.88]}
      />
      <T.Mesh
        geometry={gltf.nodes.pasted__pPlane7.geometry}
        material={gltf.materials.lambert1}
        position={[0, 6.11, -8.87]}
      />
      <T.Mesh
        geometry={gltf.nodes.pasted__pasted__pPlane5.geometry}
        material={gltf.materials.lambert1}
        position={[0, 0.8, -11.51]}
      />
    </T.Group>
    <T.Mesh
      geometry={gltf.nodes.pPlane1.geometry}
      material={gltf.materials.lambert1}
      position={[0, 0.1, -0.01]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane2.geometry}
      material={gltf.materials.lambert1}
      position={[0, -0.15, -0.03]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane3.geometry}
      material={gltf.materials.lambert1}
      position={[0, 0.03, -0.03]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane4.geometry}
      material={gltf.materials.lambert1}
      position={[-0.01, 0.03, -0.06]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPipe1.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.1, 0.12]}
      rotation={[Math.PI / 2, 0, 1.58]}
      scale={[0.04, 0.01, 0.01]}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane5.geometry}
      material={gltf.materials.lambert1}
      position={[-0.04, 0.1, 0.01]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane6.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.07, 0.02]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pCylinder1.geometry}
      material={gltf.materials.lambert1}
      position={[-0.04, 0.09, 0.09]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pCylinder2.geometry}
      material={gltf.materials.lambert1}
      position={[-0.04, 0.09, 0.05]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane7.geometry}
      material={gltf.materials.lambert1}
      position={[-0.04, 0.09, 0.06]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane8.geometry}
      material={gltf.materials.lambert1}
      position={[0, 0.13, -0.11]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane9.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.13, 0.09]}
      rotation={[Math.PI / 2, 0, 1.56]}
      scale={[0.01, 0.02, 0.01]}
    />
    <T.Mesh
      geometry={gltf.nodes.pPipe2.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.13, 0.05]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pCylinder3.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.1, 0.14]}
      rotation={[Math.PI / 2, 0, 1.58]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pPipe3.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.1, 0.2]}
      rotation={[Math.PI / 2, 0, 1.57]}
      scale={[0.71, 0.01, 0.01]}
    />
    <T.Mesh
      geometry={gltf.nodes.pPlane10.geometry}
      material={gltf.materials.lambert1}
      position={[-0.02, 0.07, 0.01]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.pSphere1.geometry}
      material={gltf.materials.lambert1}
      position={[-0.01, -0.02, -0.03]}
      rotation={[Math.PI / 2, 0, 0]}
      scale={0.01}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F5c.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F5b.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F5a.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F4c.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F4b.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F4a.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F3c.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F3b.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F3a.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F2c.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.18, 0.25]}
      rotation={[0.83, 0, 0]}
      scale={[1.08, 1.29, 1.08]}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F2b.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.21, 0.18]}
      rotation={[0.59, 0.2, 0.03]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F2a.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.16, 0.21]}
      rotation={[0.85, 0.12, 0.01]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F1b.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_F1a.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_UA.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_H2.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
    <T.Mesh
      geometry={gltf.nodes.CSS_Arms_OBJ_Smoothed_H1.geometry}
      material={gltf.materials['CSS_Arms_OBJ_Smoothed_:default2']}
      position={[-0.01, 0.07, 0.23]}
      rotation={[1.16, 0, 0]}
      scale={1.08}
    />
  {:catch err}
    {@render error?.({ error: err })}
  {/await}

  {@render children?.({ ref })}
</T.Group>
