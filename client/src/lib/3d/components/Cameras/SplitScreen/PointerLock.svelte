<script lang="ts">
  import { run } from 'svelte/legacy';

  import { createEventDispatcher, onDestroy } from 'svelte'
  import { Euler, PerspectiveCamera } from 'three'
  import { useThrelte } from '@threlte/core'
  import { birdView, inPointerLock } from '$stores/cameraStores'
  import { getYawAngle } from '$lib/helper'


  import * as THREE from 'three'
  interface Props {
    cameras?: PerspectiveCamera[]; // pass all cameras here
    minPolarAngle?: number; // radians
    maxPolarAngle?: any; // radians
    pointerSpeed?: number;
  }

  let {
    cameras = [],
    minPolarAngle = 0,
    maxPolarAngle = Math.PI,
    pointerSpeed = 1.0
  }: Props = $props();

  let isLocked = $state(false)
  const { renderer, invalidate } = useThrelte()
  const domElement = renderer.domElement
  const dispatch = createEventDispatcher()
  const _euler = new Euler(0, 0, 0, 'YXZ')
  const _PI_2 = Math.PI / 2

  if (!renderer) {
    throw new Error(
      'Threlte Context missing: Is <PointerLockControls> a child of <Canvas>?'
    )
  }

  const onChange = () => {
    invalidate()
    dispatch('change')
  }

  export const lock = () => {
    domElement.requestPointerLock()
    inPointerLock.set(true)
  }

  export const unlock = () => {
    document.exitPointerLock()
    inPointerLock.set(false)
  }

  domElement.addEventListener('click', () => {
    if (!isLocked && !$birdView) {
      lock()
    }
  })

  domElement.addEventListener('mousemove', onMouseMove)
  domElement.ownerDocument.addEventListener(
    'pointerlockchange',
    onPointerlockChange
  )
  domElement.ownerDocument.addEventListener(
    'pointerlockerror',
    onPointerlockError
  )

  onDestroy(() => {
    domElement.removeEventListener('mousemove', onMouseMove)
    domElement.ownerDocument.removeEventListener(
      'pointerlockchange',
      onPointerlockChange
    )
    domElement.ownerDocument.removeEventListener(
      'pointerlockerror',
      onPointerlockError
    )
  })

  function onMouseMove(event: MouseEvent) {
    if (!isLocked || cameras.length === 0) return

    const { movementX, movementY } = event
    cameras.forEach((camera) => {
      const euler = new Euler(0, 0, 0, 'YXZ')
      euler.setFromQuaternion(camera.quaternion)
      euler.y -= movementX * 0.002 * pointerSpeed
      euler.x -= movementY * 0.002 * pointerSpeed
      euler.x = Math.max(
        _PI_2 - maxPolarAngle,
        Math.min(_PI_2 - minPolarAngle, euler.x)
      )
      camera.quaternion.setFromEuler(euler)
    })

    onChange()
  }

  function onPointerlockChange() {
    if (document.pointerLockElement === domElement) {
      dispatch('lock')
      isLocked = true
      inPointerLock.set(true)
    } else {
      dispatch('unlock')
      isLocked = false
      inPointerLock.set(false)
    }
  }

  function onPointerlockError() {
    console.error('PointerLockControls: Unable to use Pointer Lock API')
  }

  run(() => {
    if ($birdView && isLocked) {
      unlock()
    }
  });
</script>
