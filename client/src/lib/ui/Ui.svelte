<script lang="ts">
  import StartGame from './StartGame.svelte'
  import InGameOverlay from './ingame/InGameOverlay.svelte'
  import Banner from './ingame/Banner.svelte'
  import WaitingForTurn from './ingame/banner/WaitingForTurn.svelte'
  import Button from './Button.svelte'
  import { Eraser, Repeat, Send } from 'lucide-svelte'
  import GameFinished from './ingame/GameFinished.svelte'
  import getGame from '$lib/api/svelte/context'

  let {
    session,
    isCurrentPlayersTurn,
    move: {
      isRecording,
      isReplaying,
      hasRecorded,
      submit,
      replay,
      reset,
      startRecording,
    },
  } = getGame()

  let justRecorded: boolean = $state(false)
</script>

<div class="pointer-events-auto" style="justify-content: space-between;">
  {#if $session?.state === 3}
    <GameFinished />
  {:else}
    <InGameOverlay />

    {#if $hasRecorded && !$isReplaying}
      <Banner>
        <div class="flex flex-col items-center">
          <h1 class="text-4xl font-black text-white">Time is up!</h1>
          <div class="flex justify-around mt-4">
            <Button
              on:click={reset}
              className="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Eraser class="inline-block" />
              <div>Reset</div>
            </Button>
            <Button
              on:click={replay}
              className="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Repeat class="inline-block" />
              <div>Replay</div>
            </Button>
            <Button
              on:click={submit}
              className="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              <Send class="inline-block" />
              Submit Move
            </Button>
          </div>
        </div>
      </Banner>
    {:else if !$isRecording && !$isReplaying && $isCurrentPlayersTurn && !justRecorded}
      <Banner color="#65a30d">
        <div class="flex flex-col items-center">
          <h1 class="text-4xl font-black text-white">Your turn!</h1>
          <div class="flex justify-around mt-4">
            <Button
              on:click={startRecording}
              className="bg-gray-900 border-gray-900 text-white hover:bg-white hover:text-gray-900 flex gap-2 align-middle"
            >
              Play
            </Button>
          </div>
        </div>
      </Banner>
    {:else if !$isCurrentPlayersTurn || justRecorded}
      <WaitingForTurn />
    {/if}

    <StartGame />
  {/if}
</div>
