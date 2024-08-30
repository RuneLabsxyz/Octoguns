
#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32,
} 

#[derive(Copy, Drop, Serde)]
struct Action {
    angle: u32, // 0 to 360
    step: u8,
}

#[derive(Clone, Drop, Serde)]
struct CharacterMove {
    character_ids: Array<u32>,
    movement: Array<IVec2>,
    actions: Array<Action>,
}

#[derive(Copy, Drop, Serde)]
struct IVec2 {
    x: u32,
    y: u32,
    xdir: bool,
    ydir: bool
}


