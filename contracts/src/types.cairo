
#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32,
} 

#[derive(Copy, Drop, Serde)]
struct Action {
    action_type: u32, // actually an angle DO NOT CHANGE 360 degrees for shooting
    step: u8,
}

#[derive(Clone, Drop, Serde)]
struct CharacterMove {
    character_ids: Array<u32>,
    movement: Array<Vec2>,
    actions: Array<Action>,
}

#[derive(Drop, Copy)]
pub struct CharacterPosition {
    pub id: u32,
    pub coords: Vec2,
    pub max_steps: u32,
    pub current_step: u32,
}

#[generate_trait]
impl CharacterPositionImpl of CharacterPositionTrait {
    fn new(id: u32, x: u32, y:u32, max_steps: u32, current_step: u32) -> CharacterPosition {
        CharacterPosition {id, coords: Vec2 {x,y}, max_steps, current_step}
    }
}

