<script lang="ts">
	import { Router, Link, Route } from "svelte-routing";
	import StartJoin from "./components/pages/StartJoin.svelte";
	import Home from "./components/pages/Home.svelte";
	import GameCanvas from "./components/pages/GameCanvas.svelte";
	

	
  export let url = "";

</script>

<Router {url}>

  <div>
    <Route path="/start" component={StartJoin} />
    <Route path="/game" component={GameCanvas} />
    <Route path="/game/:id" component={GameCanvas} />
    <Route path="/"><Home /></Route>
  </div>
</Router>