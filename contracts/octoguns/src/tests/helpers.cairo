use octoguns::lib::default_spawns::generate_character_positions;
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use octoguns::types::Vec2;


fn get_test_player_character_array(size: u8) -> Array<Array<CharacterPosition>> {
    let mut index: u8 = 0;
    let mut chars: Array<CharacterPosition> = ArrayTrait::new();
    while index < size {
        chars.append(CharacterPositionTrait::new(index.into(), Vec2 { x: 20000, y: 20000 }, 100));
        index += 1;
    };
    let mut res: Array<Array<CharacterPosition>> = ArrayTrait::new();
    res.append(chars);
    res
}

fn get_test_opp_character_array(size: u8) -> Array<CharacterPosition> {
    let mut index: u8 = 0;
    let mut res: Array<CharacterPosition> = ArrayTrait::new();
    while index < size.into() {
        res.append(CharacterPositionTrait::new(index.into(), Vec2 { x: 80000, y: 20000 }, 100));
        index += 1;
    };
    res
}

