import { get } from 'svelte/store'
import { dojoStore, getDojo } from '$stores/dojoStore'
import { setup, type SetupResult } from '$src/dojo/setup'
import { componentValueStore } from '$src/dojo/componentValueStore'


const sessionStore = (id: string) => {
    const object = {
        async setup() {
            const {
                clientComponents,
                torii,
                client
            } = await getDojo();

            // Compute the hash
            const hash = torii.poseidonHash([BigInt(id).toString()]);
            const sessionStore = componentValueStore(clientComponents.Session, hash);

            
        }
    }
}