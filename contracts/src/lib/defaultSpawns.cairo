use array::ArrayTrait;
use core::debug::PrintTrait;
use octoguns::types::{Vec2, CharacterPosition};

fn generate_character_positions(player_id: u8) -> Array<Vec2> {
    assert(player_id == 1 || player_id == 2, 'Invalid player ID');

    let mut positions = ArrayTrait::new();
    let is_player_one = player_id == 1;

    // Define the x-coordinate for each player
    let x = if is_player_one {
        200_u32 // Player one spawns at x = 200
    } else {
        10000_u32 // Player two spawns at x = 10000
    };

    let num_characters = 8;
    let mut count = 0;
    while count < num_characters {
        // Calculate y position, distributing characters from 200 to 10000
        let y = 200_u32 + (count * 1400_u32); // (10000 - 200) / 7 ≈ 1400
        
        positions.append(Vec2 { x, y });
        count += 1;
    };

    positions
}