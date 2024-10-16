
// Generated by dojo-bindgen on Fri, 4 Oct 2024 22:01:20 +0000. Do not modify this file manually.
// Import the necessary types from the recs SDK
// generate again with `sozo build --typescript` 
import { defineComponent, Type as RecsType, type World } from "@dojoengine/recs";

export type ContractComponents = Awaited<ReturnType<typeof defineContractComponents>>;



// Type definition for `dojo::model::layout::Layout` enum
export type Layout = { type: 'Fixed'; value: RecsType.NumberArray; } | { type: 'Struct'; value: RecsType.StringArray; } | { type: 'Tuple'; value: RecsType.StringArray; } | { type: 'Array'; value: RecsType.StringArray; } | { type: 'ByteArray'; } | { type: 'Enum'; value: RecsType.StringArray; };

export const LayoutDefinition = {
    type: RecsType.String,
    value: RecsType.String
};
        
// Type definition for `octoguns::models::bullet::Bullet` struct
export interface Bullet {
    bullet_id: Number;
    shot_step: Number;
    shot_by: Number;
    shot_at: Vec2;
    velocity: IVec2;
    
}

export const IVec2Definition = {
    x: RecsType.Number,
    y: RecsType.Number,
    xdir: RecsType.Boolean,
    ydir: RecsType.Boolean,
    
};

export const Vec2Definition = {
    x: RecsType.Number,
    y: RecsType.Number,
    
};

// Type definition for `octoguns::types::Vec2` struct
export interface Vec2 {
    x: Number;
    y: Number;
    
}
export const BulletDefinition = {
    bullet_id: RecsType.Number,
    shot_step: RecsType.Number,
    shot_by: RecsType.Number,
    shot_at: Vec2Definition,
    velocity: IVec2Definition,
    
};

// Type definition for `core::byte_array::ByteArray` struct
export interface ByteArray {
    data: String[];
    pending_word: BigInt;
    pending_word_len: Number;
    
}
export const ByteArrayDefinition = {
    data: RecsType.StringArray,
    pending_word: RecsType.BigInt,
    pending_word_len: RecsType.Number,
    
};

// Type definition for `dojo::model::layout::FieldLayout` struct
export interface FieldLayout {
    selector: BigInt;
    layout: Layout;
    
}
export const FieldLayoutDefinition = {
    selector: RecsType.BigInt,
    layout: LayoutDefinition,
    
};

// Type definition for `octoguns::types::IVec2` struct
export interface IVec2 {
    x: Number;
    y: Number;
    xdir: Boolean;
    ydir: Boolean;
    
}



// Type definition for `octoguns::models::characters::CharacterModel` struct
export interface CharacterModel {
    entity_id: Number;
    session_id: Number;
    player_id: BigInt;
    steps_amount: Number;
    
}
export const CharacterModelDefinition = {
    entity_id: RecsType.Number,
    session_id: RecsType.Number,
    player_id: RecsType.BigInt,
    steps_amount: RecsType.Number,
    
};


// Type definition for `octoguns::models::characters::CharacterPosition` struct
export interface CharacterPosition {
    id: Number;
    coords: Vec2;
    max_steps: Number;
    current_step: Number;
    
}
export const CharacterPositionDefinition = {
    id: RecsType.Number,
    coords: Vec2Definition,
    max_steps: RecsType.Number,
    current_step: RecsType.Number,
    
};


// Type definition for `octoguns::models::global::Global` struct
export interface Global {
    id: Number;
    pending_sessions: Number[];
    map_count: Number;
    
}
export const GlobalDefinition = {
    id: RecsType.Number,
    pending_sessions: RecsType.NumberArray,
    map_count: RecsType.Number,
    
};


// Type definition for `octoguns::models::map::Map` struct
export interface Map {
    map_id: Number;
    map_objects: Number[];
    
}
export const MapDefinition = {
    map_id: RecsType.Number,
    map_objects: RecsType.NumberArray,
    
};


// Type definition for `octoguns::models::player::Player` struct
export interface Player {
    player: BigInt;
    games: Number[];
    
}
export const PlayerDefinition = {
    player: RecsType.BigInt,
    games: RecsType.NumberArray,
    
};


// Type definition for `octoguns::models::sessions::Session` struct
export interface Session {
    session_id: Number;
    player1: BigInt;
    player2: BigInt;
    map_id: Number;
    state: Number;
    
}
export const SessionDefinition = {
    session_id: RecsType.Number,
    player1: RecsType.BigInt,
    player2: RecsType.BigInt,
    map_id: RecsType.Number,
    state: RecsType.Number,
    
};


// Type definition for `octoguns::models::sessions::SessionMeta` struct
export interface SessionMeta {
    session_id: Number;
    turn_count: Number;
    p1_character: Number;
    p2_character: Number;
    bullets: Number[];
    
}
export const SessionMetaDefinition = {
    session_id: RecsType.Number,
    turn_count: RecsType.Number,
    p1_character: RecsType.Number,
    p2_character: RecsType.Number,
    bullets: RecsType.NumberArray,
    
};


// Type definition for `octoguns::models::sessions::SessionPrimitives` struct
export interface SessionPrimitives {
    session_id: Number;
    bullet_speed: Number;
    bullet_sub_steps: Number;
    bullets_per_turn: Number;
    sub_moves_per_turn: Number;
    max_distance_per_sub_move: Number;
    
}
export const SessionPrimitivesDefinition = {
    session_id: RecsType.Number,
    bullet_speed: RecsType.Number,
    bullet_sub_steps: RecsType.Number,
    bullets_per_turn: RecsType.Number,
    sub_moves_per_turn: RecsType.Number,
    max_distance_per_sub_move: RecsType.Number,
    
};


// Type definition for `octoguns::types::Shot` struct
export interface Shot {
    angle: Number;
    step: Number;
    
}
export const ShotDefinition = {
    angle: RecsType.Number,
    step: RecsType.Number,
    
};

// Type definition for `octoguns::models::turndata::TurnData` struct
export interface TurnData {
    session_id: Number;
    turn_number: Number;
    moves: TurnMove;
    
}

export const TurnMoveDefinition = {
    sub_moves: RecsType.StringArray,
    shots: RecsType.StringArray,
    
};

export const TurnDataDefinition = {
    session_id: RecsType.Number,
    turn_number: RecsType.Number,
    moves: TurnMoveDefinition,
    
};

// Type definition for `octoguns::types::TurnMove` struct
export interface TurnMove {
    sub_moves: String[];
    shots: String[];
    
}


export function defineContractComponents(world: World) {
    return {

        // Model definition for `octoguns::models::bullet::Bullet` model
        Bullet: (() => {
            return defineComponent(
                world,
                {
                    bullet_id: RecsType.Number,
                    shot_step: RecsType.Number,
                    shot_by: RecsType.Number,
                    shot_at: Vec2Definition,
                    velocity: IVec2Definition,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "Bullet",
                        types: ["u32", "u16", "u32"],
                        customTypes: ["Vec2", "IVec2"],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::characters::CharacterModel` model
        CharacterModel: (() => {
            return defineComponent(
                world,
                {
                    entity_id: RecsType.Number,
                    session_id: RecsType.Number,
                    player_id: RecsType.BigInt,
                    steps_amount: RecsType.Number,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "CharacterModel",
                        types: ["u32", "u32", "ContractAddress", "u32"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::characters::CharacterPosition` model
        CharacterPosition: (() => {
            return defineComponent(
                world,
                {
                    id: RecsType.Number,
                    coords: Vec2Definition,
                    max_steps: RecsType.Number,
                    current_step: RecsType.Number,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "CharacterPosition",
                        types: ["u32", "u32", "u32"],
                        customTypes: ["Vec2"],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::global::Global` model
        Global: (() => {
            return defineComponent(
                world,
                {
                    id: RecsType.Number,
                    pending_sessions: RecsType.NumberArray,
                    map_count: RecsType.Number,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "Global",
                        types: ["u32", "array", "u32"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::map::Map` model
        Map: (() => {
            return defineComponent(
                world,
                {
                    map_id: RecsType.Number,
                    map_objects: RecsType.NumberArray,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "Map",
                        types: ["u32", "array"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::player::Player` model
        Player: (() => {
            return defineComponent(
                world,
                {
                    player: RecsType.BigInt,
                    games: RecsType.NumberArray,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "Player",
                        types: ["ContractAddress", "array"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::sessions::Session` model
        Session: (() => {
            return defineComponent(
                world,
                {
                    session_id: RecsType.Number,
                    player1: RecsType.BigInt,
                    player2: RecsType.BigInt,
                    map_id: RecsType.Number,
                    state: RecsType.Number,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "Session",
                        types: ["u32", "ContractAddress", "ContractAddress", "u32", "u8"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::sessions::SessionMeta` model
        SessionMeta: (() => {
            return defineComponent(
                world,
                {
                    session_id: RecsType.Number,
                    turn_count: RecsType.Number,
                    p1_character: RecsType.Number,
                    p2_character: RecsType.Number,
                    bullets: RecsType.NumberArray,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "SessionMeta",
                        types: ["u32", "u32", "u32", "u32", "array"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::sessions::SessionPrimitives` model
        SessionPrimitives: (() => {
            return defineComponent(
                world,
                {
                    session_id: RecsType.Number,
                    bullet_speed: RecsType.Number,
                    bullet_sub_steps: RecsType.Number,
                    bullets_per_turn: RecsType.Number,
                    sub_moves_per_turn: RecsType.Number,
                    max_distance_per_sub_move: RecsType.Number,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "SessionPrimitives",
                        types: ["u32", "u64", "u32", "u32", "u32", "u32"],
                        customTypes: [],
                    },
                }
            );
        })(),

        // Model definition for `octoguns::models::turndata::TurnData` model
        TurnData: (() => {
            return defineComponent(
                world,
                {
                    session_id: RecsType.Number,
                    turn_number: RecsType.Number,
                    moves: TurnMoveDefinition,
                },
                {
                    metadata: {
                        namespace: "octoguns",
                        name: "TurnData",
                        types: ["u32", "u32"],
                        customTypes: ["TurnMove"],
                    },
                }
            );
        })(),
    };
}
