import { DojoProvider } from "@dojoengine/core";
import { Account } from "starknet";
import * as models from "./models.gen";

export async function setupWorld(provider: DojoProvider) {

	const queue_queue = async (account: Account, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "queue",
					calldata: [game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_dequeue = async (account: Account, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "dequeue",
					calldata: [game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_matchmake = async (account: Account, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "matchmake",
					calldata: [game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_settle = async (account: Account, game: number, gameId: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "settle",
					calldata: [game, gameId],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_getElo = async (account: Account, address: string, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "get_elo",
					calldata: [address, game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_getQueueLength = async (account: Account, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "get_queue_length",
					calldata: [game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	const queue_getStatus = async (account: Account, address: string, game: number, playlist: number) => {
		try {
			return await provider.execute(
				account,
				{
					contractName: "queue",
					entryPoint: "get_status",
					calldata: [address, game, playlist],
				}
			);
		} catch (error) {
			console.error(error);
		}
	};

	return {
		queue: {
			queue: queue_queue,
			dequeue: queue_dequeue,
			matchmake: queue_matchmake,
			settle: queue_settle,
			getElo: queue_getElo,
			getQueueLength: queue_getQueueLength,
			getStatus: queue_getStatus,
		},
	};
}