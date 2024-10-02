use starknet::{ContractAddress, contract_address_const};
use octoguns::consts::{BULLET_SPEED, BULLET_SUBSTEPS, MOVE_SPEED, STEP_COUNT};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Session {
    #[key]
    pub session_id: u32,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub map_id: u32,
    pub state: u8, // 0: waiting for seconde player. 1 waiting for spawn, 2 in game, 3 ended.
}

#[generate_trait]
impl SessionImpl of SessionTrait {
    fn new(session_id: u32, player1: ContractAddress, map_id: u32) -> Session {
        Session { session_id, player1, player2: contract_address_const::<0x0>(), map_id, state: 0 }
    }
    fn new_closed(
        session_id: u32, player1: ContractAddress, player2: ContractAddress, map_id: u32
    ) -> Session {
        Session { session_id, player1, player2, map_id, state: 0 }
    }
    fn join(ref self: Session, player2: ContractAddress) {
        self.player2 = player2;
        self.state = 1;
    }
}

#[derive(Drop, Serde)]
#[dojo::model]
pub struct SessionMeta {
    #[key]
    pub session_id: u32,
    pub turn_count: u32, // mod 2 = 1 is player 2 and mod 2 = 0 is player 1
    pub p1_character: u32,
    pub p2_character: u32,
    pub bullets: Array<u32>,
}

#[generate_trait]
impl SessionMetaImpl of SessionMetaTrait {
    fn new(session_id: u32) -> SessionMeta {
        SessionMeta {
            session_id, turn_count: 0, bullets: ArrayTrait::new(), p1_character: 0, p2_character: 0
        }
    }
    fn next_turn(ref self: SessionMeta) {
        self.turn_count += 1;
    }
    fn add_bullet(ref self: SessionMeta, bullet_id: u32) {
        self.bullets.append(bullet_id);
    }
    fn set_new_bullets(ref self: SessionMeta, bullets: Array<u32>) {
        self.bullets = bullets;
    }
}

#[derive(Drop, Serde)]
#[dojo::model]
pub struct SessionPrimitives {
    #[key]
    pub session_id: u32,
    pub bullet_speed: u32,
    pub bullet_sub_steps: u32,
    pub bullets_per_turn: u32,
    pub sub_moves_per_turn: u32,
    pub max_distance_per_sub_move: u32,
}

#[generate_trait]
impl SessionPrimitivesImpl of SessionPrimitivesTrait {
    
    fn default(session_id: u32) -> SessionPrimitives {
        SessionPrimitives {
            session_id,
            bullet_speed: BULLET_SPEED,
            bullet_sub_steps: BULLET_SUBSTEPS,
            bullets_per_turn: 1,
            sub_moves_per_turn: STEP_COUNT,
            max_distance_per_sub_move: MOVE_SPEED
        }
    }

    fn new(
        session_id: u32,
        bullet_speed: u32,
        bullet_sub_steps: u32,
        bullets_per_turn: u32,
        sub_moves_per_turn: u32,
        max_distance_per_sub_move: u32
    ) -> SessionPrimitives {
        SessionPrimitives {
            session_id,
            bullet_speed,
            bullet_sub_steps,
            bullets_per_turn,
            sub_moves_per_turn,
            max_distance_per_sub_move
        }
    }
}
