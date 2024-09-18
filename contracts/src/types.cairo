
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

#[derive(Clone, Drop, Serde, Introspect)]
struct MapObjects {
    objects: Array<u16>,
}


