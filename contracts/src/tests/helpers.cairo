use octoguns::lib::defaultSpawns::generate_character_positions;
use octoguns::models::character::{CharacterPosition, CharacterPositionTrait};


fn get_test_character_array() -> Array<CharacterPosition>{
    let positions = generate_character_positions(1);
    let mut index = 0;
    let mut res = ArrayTrait::new();
    while index < positions.len() {
        let position = *positions.at(index);
        res.append(CharacterPositionTrait::new(index, position, 100, 0));
        index +=1;
    };
    res
}



