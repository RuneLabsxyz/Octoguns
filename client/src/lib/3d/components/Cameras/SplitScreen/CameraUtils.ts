import { PerspectiveCamera, WebGLRenderer, Scene } from 'three'


export function renderCameras(
  cameras: PerspectiveCamera[],
  numCameras: number,
  renderer: WebGLRenderer,
  scene: Scene
) {
  try {
    const { width, height } = renderer.domElement

    if (cameras.length === numCameras) {
      try {
        const rows = Math.ceil(Math.sqrt(numCameras))
        const cols = Math.ceil(numCameras / rows)
        const cameraWidth = width / cols
        const cameraHeight = height / rows

        cameras.forEach((camera, index) => {
          try {
            const row = Math.floor(index / cols)
            const col = index % cols

            camera.aspect = cameraWidth / cameraHeight
            camera.updateProjectionMatrix()

            renderer.setScissorTest(true)
            renderer.setViewport(
              col * cameraWidth,
              row * cameraHeight,
              cameraWidth,
              cameraHeight
            )
            renderer.setScissor(
              col * cameraWidth,
              row * cameraHeight,
              cameraWidth,
              cameraHeight
            )
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
            renderer.render(scene, camera)
          } catch (error) {
            console.error(`Error rendering camera ${index}:`, error)
          }
        })

        renderer.setScissorTest(false)
      } catch (error) {
        console.error('Error setting up camera layout:', error)
      }
    }
  } catch (error) {
    console.error('Error in renderCameras:', error)
  }
}

export function resetCamera(
  camera: PerspectiveCamera,
  renderer: WebGLRenderer
) {
  const { width, height } = renderer.domElement

  // Reset renderer settings
  renderer.setViewport(0, 0, width, height)
  renderer.setScissor(0, 0, width, height)
  renderer.setScissorTest(false)

  // Update camera aspect ratio
  camera.aspect = width / height
  camera.updateProjectionMatrix()
}
