<script>
  // Import necessary  features for navigation
  import { page } from '$app/stores'
</script>

<nav class="flex flex-row p-4">
  <ul class="flex flex-row space-x-4">
    <li><a href="/client/games" class="p-2">Games</a></li>
    <li><a href="/client/mapmaker" class="p-2">Mapmaker</a></li>
    <li><a href="/client/myGames" class="p-2">My Games</a></li>
  </ul>
</nav>

<div class="p-4">
  <slot />
</div>
