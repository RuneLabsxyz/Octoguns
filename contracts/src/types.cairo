
#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32,
} 

#[derive(Copy, Drop, Serde)]
struct Shot {
    angle: u64, // 0 to 360
    step: u8,
}

#[derive(Clone, Drop, Serde)]
struct TurnMove {
    characters: Array<u32>,
    sub_moves: Array<IVec2>,
    shots: Array<Shot>,
}

#[derive(Copy, Drop, Serde)]
struct IVec2 {
    x: u32,
    y: u32,
    xdir: bool,
    ydir: bool
}

#[derive(Copy, Drop, Serde)]
struct MapObjects {
    objects: Array<u16>,
}


