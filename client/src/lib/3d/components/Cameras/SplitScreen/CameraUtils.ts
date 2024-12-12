import { PerspectiveCamera, WebGLRenderer, Scene, Vector4, ArrayCamera } from 'three'


export function renderCameras(
  cameras: PerspectiveCamera[],
  renderer: WebGLRenderer,
  scene: Scene
) {
  try {
    const { width, height } = renderer.domElement
    cameras = [...cameras]

      try {
        const rows = Math.ceil(Math.sqrt(cameras.length))
        const cols = Math.ceil(cameras.length / rows)
        const cameraWidth = width / cols
        const cameraHeight = height / rows

        cameras.forEach((camera, index) => {
          try {
            const row = Math.floor(index / cols)
            const col = index % cols

            camera.aspect = cameraWidth / cameraHeight
            camera.updateProjectionMatrix()

            renderer.setScissorTest(true)
            camera.viewport = new Vector4(
              col * cameraWidth,
              row * cameraHeight,
              cameraWidth,
              cameraHeight
            )
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
          } catch (error) {
            console.error(`Error rendering camera ${index}:`, error)
          }
        })

        let camera = new ArrayCamera(cameras)

        renderer.setScissorTest(false)
        renderer.render(scene, camera)

      } catch (error) {
        console.error('Error setting up camera layout:', error)
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
