import type { SchemaType } from "@dojoengine/sdk";

// Type definition for `planetelo::models::Elo` struct
export interface Elo {
	fieldOrder: string[];
	player: string;
	game: number;
	playlist: number;
	value: number;
}

// Type definition for `planetelo::models::EloValue` struct
export interface EloValue {
	fieldOrder: string[];
	value: number;
}

// Type definition for `planetelo::models::GameValue` struct
export interface GameValue {
	fieldOrder: string[];
	playlist: number;
	player1: string;
	player2: string;
	timestamp: number;
}

// Type definition for `planetelo::models::Game` struct
export interface Game {
	fieldOrder: string[];
	game: number;
	id: number;
	playlist: number;
	player1: string;
	player2: string;
	timestamp: number;
}

// Type definition for `planetelo::models::Player` struct
export interface Player {
	fieldOrder: string[];
	player: string;
	games_played: number;
	queues_joined: number;
}

// Type definition for `planetelo::models::PlayerValue` struct
export interface PlayerValue {
	fieldOrder: string[];
	games_played: number;
	queues_joined: number;
}

// Type definition for `planetelo::models::PlayerStatusValue` struct
export interface PlayerStatusValue {
	fieldOrder: string[];
	status: QueueStatus;
	index: number;
}

// Type definition for `planetelo::models::PlayerStatus` struct
export interface PlayerStatus {
	fieldOrder: string[];
	player: string;
	game: number;
	playlist: number;
	status: QueueStatus;
	index: number;
}

// Type definition for `planetelo::models::Queue` struct
export interface Queue {
	fieldOrder: string[];
	game: number;
	playlist: number;
	length: number;
}

// Type definition for `planetelo::models::QueueValue` struct
export interface QueueValue {
	fieldOrder: string[];
	length: number;
}

// Type definition for `planetelo::models::QueueIndexValue` struct
export interface QueueIndexValue {
	fieldOrder: string[];
	player: string;
	timestamp: number;
	elo: number;
}

// Type definition for `planetelo::models::QueueIndex` struct
export interface QueueIndex {
	fieldOrder: string[];
	game: number;
	playlist: number;
	index: number;
	player: string;
	timestamp: number;
	elo: number;
}

// Type definition for `planetelo::models::QueueStatus` enum
export enum QueueStatus {
	None,
	Queued,
	InGame,
}

export interface PlaneteloSchemaType extends SchemaType {
	planetelo: {
		Elo: Elo,
		EloValue: EloValue,
		GameValue: GameValue,
		Game: Game,
		Player: Player,
		PlayerValue: PlayerValue,
		PlayerStatusValue: PlayerStatusValue,
		PlayerStatus: PlayerStatus,
		Queue: Queue,
		QueueValue: QueueValue,
		QueueIndexValue: QueueIndexValue,
		QueueIndex: QueueIndex,
		ERC__Balance: ERC__Balance,
		ERC__Token: ERC__Token,
		ERC__Transfer: ERC__Transfer,
	},
}
export const schema: PlaneteloSchemaType = {
	planetelo: {
		Elo: {
			fieldOrder: ['player', 'game', 'playlist', 'value'],
			player: "",
			game: 0,
			playlist: 0,
			value: 0,
		},
		EloValue: {
			fieldOrder: ['value'],
			value: 0,
		},
		GameValue: {
			fieldOrder: ['playlist', 'player1', 'player2', 'timestamp'],
			playlist: 0,
			player1: "",
			player2: "",
			timestamp: 0,
		},
		Game: {
			fieldOrder: ['game', 'id', 'playlist', 'player1', 'player2', 'timestamp'],
			game: 0,
			id: 0,
			playlist: 0,
			player1: "",
			player2: "",
			timestamp: 0,
		},
		Player: {
			fieldOrder: ['player', 'games_played', 'queues_joined'],
			player: "",
			games_played: 0,
			queues_joined: 0,
		},
		PlayerValue: {
			fieldOrder: ['games_played', 'queues_joined'],
			games_played: 0,
			queues_joined: 0,
		},
		PlayerStatusValue: {
			fieldOrder: ['status', 'index'],
			status: QueueStatus.None,
			index: 0,
		},
		PlayerStatus: {
			fieldOrder: ['player', 'game', 'playlist', 'status', 'index'],
			player: "",
			game: 0,
			playlist: 0,
			status: QueueStatus.None,
			index: 0,
		},
		Queue: {
			fieldOrder: ['game', 'playlist', 'length'],
			game: 0,
			playlist: 0,
			length: 0,
		},
		QueueValue: {
			fieldOrder: ['length'],
			length: 0,
		},
		QueueIndexValue: {
			fieldOrder: ['player', 'timestamp', 'elo'],
			player: "",
			timestamp: 0,
			elo: 0,
		},
		QueueIndex: {
			fieldOrder: ['game', 'playlist', 'index', 'player', 'timestamp', 'elo'],
			game: 0,
			playlist: 0,
			index: 0,
			player: "",
			timestamp: 0,
			elo: 0,
		},
		ERC__Balance: {
			fieldOrder: ['balance', 'type', 'tokenmetadata'],
			balance: '',
			type: 'ERC20',
			tokenMetadata: {
				fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
		},
		ERC__Token: {
			fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
			name: '',
			symbol: '',
			tokenId: '',
			decimals: '',
			contractAddress: '',
		},
		ERC__Transfer: {
			fieldOrder: ['from', 'to', 'amount', 'type', 'executed', 'tokenMetadata'],
			from: '',
			to: '',
			amount: '',
			type: 'ERC20',
			executedAt: '',
			tokenMetadata: {
				fieldOrder: ['name', 'symbol', 'tokenId', 'decimals', 'contractAddress'],
				name: '',
				symbol: '',
				tokenId: '',
				decimals: '',
				contractAddress: '',
			},
			transactionHash: '',
		},

	},
};
// Type definition for ERC__Balance struct
export type ERC__Type = 'ERC20' | 'ERC721';
export interface ERC__Balance {
    fieldOrder: string[];
    balance: string;
    type: string;
    tokenMetadata: ERC__Token;
}
export interface ERC__Token {
    fieldOrder: string[];
    name: string;
    symbol: string;
    tokenId: string;
    decimals: string;
    contractAddress: string;
}
export interface ERC__Transfer {
    fieldOrder: string[];
    from: string;
    to: string;
    amount: string;
    type: string;
    executedAt: string;
    tokenMetadata: ERC__Token;
    transactionHash: string;
}