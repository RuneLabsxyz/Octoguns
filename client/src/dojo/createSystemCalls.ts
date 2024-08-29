import { Account } from "@dojoengine/torii-wasm"
import { setupStore } from "src/stores"
import { get } from "svelte/store"

export type Vec = {
    x: number,
    y: number
}

export type Action = {
    action_type: number,
    step: number
}

export type CharacterMove = {
    characters: number[],
    moves: Vec[],
    actions: number[]

}

let {client} = get(setupStore);

export const move = async (client: any, account: Account, session_id: number, moves: CharacterMove[]) => {
    client.actions.move({account, session_id, moves});
}