<script>
</script>

<button
  class="px-5 py-2 border-4 border-black rounded-lg m-2 hover:bg-gray-300 btn shadow-md"
  on:click
>
  <slot></slot>
</button>

<style>
  .btn {
    transition: all 0.3s;
  }

  .btn:hover {
    box-shadow: black 6px 3px;
  }
</style>
