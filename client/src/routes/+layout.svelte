<script lang="ts">
  import '../app.css'

  import { getWebInstrumentations, initializeFaro } from '@grafana/faro-web-sdk'
  import { TracingInstrumentation } from '@grafana/faro-web-tracing'
  import { version } from '$app/environment'
  import { onMount } from 'svelte'
  import { PUBLIC_ENABLE_TRACING } from '$env/static/public'

  if (PUBLIC_ENABLE_TRACING === 'true') {
    onMount(() => {
      // Add faro tracing
      initializeFaro({
        url: 'https://faro-collector-prod-eu-west-2.grafana.net/collect/8a5346c1f199d050b57a00f918ce4283',
        app: {
          name: 'Octoguns',
          version: version,
          environment: 'production',
        },

        instrumentations: [
          // Mandatory, omits default instrumentations otherwise.
          ...getWebInstrumentations(),

          // Tracing package to get end-to-end visibility for HTTP requests.
          new TracingInstrumentation(),
        ],
      })
    })
  }
</script>

<slot />
