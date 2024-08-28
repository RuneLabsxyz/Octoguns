use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
pub struct Character {
    #[key]
    pub entity_id: u32,
    pub session_id: u32,
    pub player_id: ContractAddress,
    pub steps_amount: u32, // The amount of acion s this character can submit
}

#[generate_trait]
impl CharacterImpl of CharacterTrait {
    fn new(id: u32, session_id: u32, player_id: ContractAddress, steps_amount: u32) -> Character {
        Character {entity_id: id, session_id, player_id, steps_amount}
    }
}

// 10 000 x 10 000 x 10 000 map (high level position)
#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct CharacterPosition {
    pub id: u32,
    pub coords: Vec2,
    pub max_steps: u32,
    pub current_step: u32,
}

#[generate_trait]
impl PositionImpl of PositionTrait {
    fn new(entity_id: u32, x:  u32, y:u32) -> Position {
        Position {entity_id, x, y}
    }
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct Health {
    #[key]
    pub entity_id: u32,
    pub health: u8,
}

#[generate_trait]
impl HealthImpl of HealthTrait {
    fn new(entity_id: u32, health: u8) -> Health {
        Health {entity_id, health}
    }
}