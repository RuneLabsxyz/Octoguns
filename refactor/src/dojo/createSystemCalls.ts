import { Account } from "starknet"
import { type TurnData } from "$stores/gameStores"
import type { IWorld } from "./contracts.gen"

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


export const move = async (client: IWorld, account: Account, session_id: number, moves: TurnData) => {
    client.actions.move({account, session_id, moves});
}