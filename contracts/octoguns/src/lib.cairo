mod systems {
    mod start; 
    mod spawn;
    mod actions;
    mod mapmaker;
}

mod models {
    mod bullet;
    mod sessions;
    mod map;
    mod characters;
    mod global;
    mod player;
    mod turndata;
}

mod lib {
    
    mod move_utils {
        mod helpers;
        mod simulate;
        mod get_positions;
    }

    mod default_spawns;
    mod grid;
    mod trig;
    mod bitwise;
    mod dice;
}

mod tests {
    mod helpers;
    mod test_world;
}

mod consts;
mod types;
mod planetelo;
