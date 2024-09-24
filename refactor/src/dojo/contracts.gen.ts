
// Generated by dojo-bindgen on Tue, 24 Sep 2024 00:56:56 +0000. Do not modify this file manually.
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
            

        return {
            world, spawn
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
        const create = async (props: { account: Account, map_id: number }) => {
            try {
                return await provider.execute(
                    props.account,
                    {
                        contractName: contract_name,
                        entrypoint: "create",
                        calldata: [props.map_id],
                    },
                    "octoguns"
                );
            } catch (error) {
                console.error("Error executing create:", error);
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
            world, create, join
        };
    }

    return {
        actions: actions(),
        mapmaker: mapmaker(),
        spawn: spawn(),
        start: start()
    };
}
