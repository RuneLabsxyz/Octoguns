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

#[derive(Copy, Drop, Serde, Introspect)]
pub struct Settings {
    pub bullet_speed: u64,
    pub bullet_steps: u32,
    pub bullets: u32,
    pub sub_moves: u32,
    pub sub_move_distance: u32,
    pub characters: u64
    pub actions: u64
}

#[derive(Drop, Serde)]
#[dojo::model]
pub struct SessionMeta {
    #[key]
    pub session_id: u32,
    pub turn_count: u32, // mod 2 = 1 is player 2 and mod 2 = 0 is player 1
    pub p1_characters: Array<u32>, 
    pub p2_characters: Array<u32>,
    pub bullets: Array<u32>,
}

#[generate_trait]
impl SessionMetaImpl of SessionMetaTrait {
    fn new(session_id: u32) -> SessionMeta {
        SessionMeta {
            session_id, 
            turn_count: 0, 
            bullets: ArrayTrait::new(), 
            p1_characters: ArrayTrait::new(), 
            p2_characters: ArrayTrait::new()
        }
    }
    fn next_turn(ref self: SessionMeta) {
        self.turn_count += 1;
    }
    fn add_bullet(ref self: SessionMeta, bullet_id: u32) {
        self.bullets.append(bullet_id);
    }
    fn add_character(ref self: SessionMeta, id: u32, player: u8) {

        if(player == 1) {
            self.p1_characters.append(id);
        }
        else if (player == 2) {
            self.p2_characters.append(id);
        }
        else {
            panic!("player must be 1 or 2");
        }
    }

    fn remove_bullet(ref self: SessionMeta, id: u32) {
        let mut new = ArrayTrait::new();
        loop {
            if let Option::Some(bullet) = self.bullets.pop_front() {
                if bullet != id {
                    new.append(bullet);
                }
            }
            else {
                break;
            }
        };
        self.bullets = new;
    }

    fn remove_character(ref self: SessionMeta, id: u32, player: u8) {
        let mut new = ArrayTrait::new();

        if(player == 1) {
            loop {
                if let Option::Some(char) = self.p1_characters.pop_front() {
                    if char != id {
                        new.append(char);
                    }
                }
                else {
                    break;
                }
            };
            self.p1_characters = new;
        }
        else if (player == 2) {
            loop {
                if let Option::Some(char) = self.p2_characters.pop_front() {
                    if char != id {
                        new.append(char);
                    }
                }
                else {
                    break;
                }
            };
            self.p2_characters = new;
        }
        else {
            panic!("player must be 1 or 2");
        }
    }
}

#[derive(Drop, Serde)]
#[dojo::model]
pub struct SessionPrimitives {
    #[key]
    pub session_id: u32,
    pub settings: Settings,
}

#[generate_trait]
impl SessionPrimitivesImpl of SessionPrimitivesTrait {

    fn new(
        session_id: u32, settings: Settings
    ) -> SessionPrimitives {
        SessionPrimitives {
            session_id,
            settings
        }
    }
}
