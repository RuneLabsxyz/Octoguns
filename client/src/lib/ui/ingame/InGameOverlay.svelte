<script lang="ts">
  import { cn } from '$lib/css/cn'
  import { birdView } from '$src/stores/cameraStores'
  import { Camera, ArrowLeftRight, User } from 'lucide-svelte'
  import StepBar from '../StepBar.svelte'
  import getGame from '$lib/api/svelte/context'

  const { turnCount } = getGame()
</script>

<div class="overflow-hidden">
  <div class="fixed w-screen flex bottom-0 overflow-hidden">
    <div class="flex-grow self-end h-5">
      <StepBar />
    </div>
    <div
      class="relative overflow-hidden pr-2 pb-2 pt-4 pl-4 text-white rounded-tl-2xl border-t-2 border-l-2 border-black flex flex-col"
    >
      <div class="flex justify-center -mt-1">
        Turn {$turnCount}
      </div>

      <div class="flex items-center gap-1 mt-2">
        <button
          class={cn('rounded-md p-1 border-2', {
            'bg-white': $birdView,
          })}
          onclick={() => ($birdView = true)}
        >
          <Camera color={$birdView ? 'black' : 'white'} />
        </button>

        <ArrowLeftRight size="16" class="h-min" />
        <button
          class={cn('rounded-md p-1 border-white border-2', {
            'bg-white': !$birdView,
          })}
          onclick={() => ($birdView = false)}
        >
          <User color={!$birdView ? 'black' : 'white'} />
        </button>
      </div>

      <div
        class="absolute right-0 bottom-0 overflow-hidden bg left-0 top-0"
      ></div>
    </div>
  </div>
</div>

<style>
  .bg {
    --size-x: 200px;
    z-index: -10;
    opacity: 0.5;
    filter: contrast(70%) brightness(20%);

    background: url('/tiled-design.svg') repeat;
    background-size: var(--size-x);
  }
</style>
