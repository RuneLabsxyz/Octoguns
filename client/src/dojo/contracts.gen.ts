
// Generated by dojo-bindgen on Wed, 2 Oct 2024 15:53:30 +0000. Do not modify this file manually.
// Import the necessary types from the recs SDK
// generate again with `sozo build --typescript` 
import { Account, byteArray } from "starknet";
import { DojoProvider } from "@dojoengine/core";
import * as models from "./models.gen";

export type IWorld = Awaited<ReturnType<typeof setupWorld>>;

export async function setupWorld(provider: DojoProvider) {
    // System definitions for `octoguns-actions` contract
    function actions() {
        const contract_name = "actions";

        
        // Call the `move` system with the specified Account and calldata
        const move = async (props: { account: Account, session_id: number, moves: models.TurnMove }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "move",
                        calldata: [props.session_id,
                props.moves.sub_moves,
                    props.moves.shots],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing move:", error);
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
            

        return {
            move, world
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
            

    
        // Call the `create` system with the specified Account and calldata
        const create = async (props: { account: Account, objects: models.MapObjects }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "create",
                        calldata: [props.objects],
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
            world, create, default_map
        };
    }

    // System definitions for `octoguns-spawn` contract
    function spawn() {
        const contract_name = "spawn";

        
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
            

        return {
            spawn, world
        };
    }

    // System definitions for `octoguns-start` contract
    function start() {
        const contract_name = "start";

        
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
                console.log('create', props.session_primitives)
                console.log('map_id', props.map_id)
                console.log('account', props.account)
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
            world, create, create_closed, join
        };
    }

    return {
        actions: actions(),
        mapmaker: mapmaker(),
        spawn: spawn(),
        start: start()
    };
}