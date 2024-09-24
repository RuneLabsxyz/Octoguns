export function playSoundEffect(filePath: string) {
  const audio = new Audio(filePath)
  audio.play()
}

export function playSoundEffectLoop(filePath: string, volume: number) {
  const audio = new Audio(filePath)
  audio.loop = true
  audio.volume = volume
  audio.play()
}

export function clickSound() {
  const audio = new Audio('/audio/client/click.wav')
  audio.play()
}
