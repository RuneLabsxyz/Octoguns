import { PerspectiveCamera, WebGLRenderer, Scene } from 'three'

export function renderCameras(
  cameras: PerspectiveCamera[],
  numCameras: number,
  renderer: WebGLRenderer,
  scene: Scene
) {
  const { width, height } = renderer.domElement

  if (cameras.length === numCameras) {
    const rows = Math.ceil(Math.sqrt(numCameras))
    const cols = Math.ceil(numCameras / rows)
    const cameraWidth = width / cols
    const cameraHeight = height / rows

    cameras.forEach((camera, index) => {
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
      renderer.render(scene, camera)
    })

    renderer.setScissorTest(false)
  }
}
