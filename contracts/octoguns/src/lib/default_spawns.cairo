use array::ArrayTrait;
use core::debug::PrintTrait;
use octoguns::types::{Vec2};


fn generate_character_positions(player_id: u8, num_characters: u64) -> Array<Vec2> {
    assert(player_id == 1 || player_id == 2, 'Invalid player ID');

    let mut positions = ArrayTrait::new();
    let is_player_one = player_id == 1;

    assert!(num_characters < 8, "Invalid count");

    // Define the x-coordinate for each player
    let x = if is_player_one {
        20000 // Player one spawns at x = 20000
    } else {
        80000 // Player two spawns at x = 80000
    };

    let offset = 10_000; //10% of the map

    let mut count = 0;

    if num_characters == 1{
        positions.append(Vec2 { x, y: 50_000 });
    }

    if num_characters == 2{
        positions.append(Vec2 { x, y: 45_000 });
        positions.append(Vec2 { x, y: 55_000 });
    }
    let mut start_y = 0;

    if num_characters % 2 == 0 {
        let char_offset = num_characters / 2;
        start_y = 50_000 - (offset * char_offset)/2;
    } else {
        let char_offset = (num_characters - 1) / 2;
        start_y = 50_000 - (offset * char_offset);
    };

    while count < num_characters {
    
        if num_characters % 2 == 0 {
            positions.append(Vec2 { x, y: start_y + (count * offset) });
        } else {
            positions.append(Vec2 { x, y: start_y + (count * offset) });
        }
        count += 1;
    };


    positions
}