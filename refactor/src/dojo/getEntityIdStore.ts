import { setupStore } from "../stores/dojoStore";
import type { Entity } from "@dojoengine/recs";
import { derived } from "svelte/store";

export function getEntityIdStore(torii: any, keys: (string | undefined)[]): (callback: (value: Entity | undefined) => void) => () => void{

    let entity_id: Entity;

    $: if (setupStore) entity_id = derived(setupStore, ($store) =>
		$store
		? torii.poseidonHash(keys)
		: undefined
	);

    return entity_id;

}