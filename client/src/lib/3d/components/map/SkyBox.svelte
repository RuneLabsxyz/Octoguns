<script lang="ts">
  import { T, Canvas } from '@threlte/core'
  import { Sky } from '@threlte/extras'
</script>

<T.Group>
  <Sky
    turbidity={10}
    rayleigh={3}
    azimuth={180}
    elevation={0.5}
    mieCoefficient={0.005}
    mieDirectionalG={0.7}
  />
</T.Group>
