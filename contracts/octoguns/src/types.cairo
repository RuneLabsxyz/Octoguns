
#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u64,
    y: u64,
} 

#[derive(Copy, Drop, Serde, Introspect)]
struct Shot {
    angle: u64, // 0 to 360
    step: u32,
}

#[derive(Clone, Drop, Serde, Introspect)]
struct Action {
    characters: Array<u32>,
    sub_moves: Array<IVec2>,
    shots: Array<Shot>,
}

#[derive(Drop, Serde, Introspect)]
struct TurnMove {
    actions: Array<Action>,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct IVec2 {
    x: u64,
    y: u64,
    xdir: bool,
    ydir: bool
}

