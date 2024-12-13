
// Generated by dojo-bindgen on Tue, 15 Oct 2024 11:08:47 +0000. Do not modify this file manually.
// Import the necessary types from the recs SDK
// generate again with `sozo build --typescript` 
import { Account, byteArray } from "starknet";
import { DojoProvider } from "@dojoengine/core";
import * as models from "./models.gen";
import { CallData } from "starknet";
import { type BigNumberish } from "starknet";
import { type TurnData } from "$lib/api/data/move";
export type IWorld = Awaited<ReturnType<typeof setupWorld>>;

export async function setupWorld(provider: DojoProvider) {
    // System definitions for `octoguns-actions` contract
    function actions() {
        const contract_name = "actions";

        
        // Call the `name` system with the specified Account and calldata
        const name = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "name",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing name:", error);
                throw error;
            }
        };
            

    
        // Call the `world` system with the specified Account and calldata
        const world = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "world",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing world:", error);
                throw error;
            }
        };
            

    
        // Call the `move` system with the specified Account and calldata
        const move = async (snAccount: Account, sessionId: BigNumberish, moves: TurnData) => {
            try {
                return await provider.execute(
                    snAccount,
                    {
                        contractName: "actions",
                        entrypoint: "move",
                        calldata: [sessionId, moves],
                    },
                    "octoguns",
                );
            } catch (error) {
                console.error(error);
            }
        };
            

        return {
            name, world, move
        };
    }

    // System definitions for `octoguns-mapmaker` contract
    function mapmaker() {
        const contract_name = "mapmaker";

        
        // Call the `world` system with the specified Account and calldata
        const world = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "world",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing world:", error);
                throw error;
            }
        };
            

    
        // Call the `name` system with the specified Account and calldata
        const name = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "name",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing name:", error);
                throw error;
            }
        };
            

    
        // Call the `create` system with the specified Account and calldata
        const create = async (props: { account: Account, grid1: bigint, grid2: bigint, grid3: bigint }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "create",
                        calldata: [props.grid1,
                props.grid2,
                props.grid3],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing create:", error);
                throw error;
            }
        };
            

    
        // Call the `default_map` system with the specified Account and calldata
        const default_map = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "default_map",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing default_map:", error);
                throw error;
            }
        };
            

        return {
            world, name, create, default_map
        };
    }

    // System definitions for `octoguns-spawn` contract
    function spawn() {
        const contract_name = "spawn";

        
        // Call the `world` system with the specified Account and calldata
        const world = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "world",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing world:", error);
                throw error;
            }
        };
            

    
        // Call the `spawn` system with the specified Account and calldata
        const spawn = async (props: { account: Account, session_id: number }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "spawn",
                        calldata: [props.session_id],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing spawn:", error);
                throw error;
            }
        };
            

    
        // Call the `name` system with the specified Account and calldata
        const name = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "name",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing name:", error);
                throw error;
            }
        };
            

        return {
            world, spawn, name
        };
    }

    // System definitions for `octoguns-start` contract
    function start() {
        const contract_name = "start";

        
        // Call the `name` system with the specified Account and calldata
        const name = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "name",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing name:", error);
                throw error;
            }
        };
            

    
        // Call the `world` system with the specified Account and calldata
        const world = async (props: { account: Account }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "world",
                        calldata: [],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing world:", error);
                throw error;
            }
        };
            

    
        // Call the `create` system with the specified Account and calldata
        const create = async (props: { account: Account, map_id: number, session_primitives: models.SessionPrimitives }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "create",
                        calldata: [props.map_id,
                props.session_primitives.session_id,
                    props.session_primitives.bullet_speed,
                    props.session_primitives.bullet_sub_steps,
                    props.session_primitives.bullets_per_turn,
                    props.session_primitives.sub_moves_per_turn,
                    props.session_primitives.max_distance_per_sub_move],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing create:", error);
                throw error;
            }
        };
            

    
        // Call the `create_closed` system with the specified Account and calldata
        const create_closed = async (props: { account: Account, map_id: number, player_address_1: bigint, player_address_2: bigint, session_primitives: models.SessionPrimitives }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "create_closed",
                        calldata: [props.map_id,
                props.player_address_1,
                props.player_address_2,
                props.session_primitives.session_id,
                    props.session_primitives.bullet_speed,
                    props.session_primitives.bullet_sub_steps,
                    props.session_primitives.bullets_per_turn,
                    props.session_primitives.sub_moves_per_turn,
                    props.session_primitives.max_distance_per_sub_move],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing create_closed:", error);
                throw error;
            }
        };
            

    
        // Call the `join` system with the specified Account and calldata
        const join = async (props: { account: Account, session_id: number }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "join",
                        calldata: [props.session_id],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing join:", error);
                throw error;
            }
        };
            

        return {
            name, world, create, create_closed, join
        };
    }

    return {
        actions: actions(),
        mapmaker: mapmaker(),
        spawn: spawn(),
        start: start()
    };
}
