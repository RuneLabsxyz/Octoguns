<script>
    import { selectionMode } from "src/stores";



</script>


  <div class="grid-overlay">
    {#each Array(8) as _}
      <div></div>
    {/each}
  </div>

<style>
    .grid-overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      pointer-events: none; /* Ensures the grid does not interfere with interactions */
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      grid-template-rows: repeat(2, 1fr);
      border: 4px solid rgba(255, 0, 200, 0.5); /* Outer border */
    }
  
    .grid-overlay div {
      border-right: 4px solid rgba(255, 0, 255, 0.5); /* Vertical lines */
      border-bottom: 4px solid rgba(255, 0, 255, 0.5); /* Horizontal lines */
    }
  
    .grid-overlay div:nth-child(4n) {
      border-right: none; /* Remove the right border on the last column */
    }
  
    .grid-overlay div:nth-last-child(-n+4) {
      border-bottom: none; /* Remove the bottom border on the last row */
    }
  </style>
  
  