use octoguns::types::{TurnMove};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait, CharacterModel};
use octoguns::models::bullet::{Bullet};
use octoguns::models::sessions::{SessionMeta};
use octoguns::types::IVec2;
use starknet::{ContractAddress, get_caller_address};
use dojo::world::WorldStorage;
use dojo::model::{ModelStorage, ModelValueStorage, Model};

use octoguns::consts::MOVE_SPEED;

fn get_all_bullets(world: WorldStorage, session_id: u32) -> Array<Bullet> {
    let mut all_live_bullets: Array<Bullet> = ArrayTrait::new();
    let session_meta: SessionMeta = world.read_model(session_id);
    let bullets = session_meta.bullets; //  type: array<u32>

    let mut i = 0;
    if bullets.len() == 0 {
        return all_live_bullets;
    }

    while i < bullets.len() {
        let bullet_id = *bullets.at(i);
        let bullet: Bullet = world.read_model(bullet_id);

        all_live_bullets.append(bullet);
        i += 1;
    };

    return all_live_bullets;
}


fn filter_out_dead_characters(
    ref all_character_positions: Array<CharacterPosition>, dead_characters: Array<u32>
) -> (Array<CharacterPosition>, Array<u32>) {
    let mut filtered_positions: Array<CharacterPosition> = ArrayTrait::new();
    let mut filtered_ids: Array<u32> = ArrayTrait::new();

    let mut all_ids = ArrayTrait::new();
    let mut i = 0;
    while i < all_character_positions.len() {
        all_ids.append((*all_character_positions.at(i)).id);
        i += 1;
    };

    if dead_characters.len() == 0 {
        return (all_character_positions.clone(), all_ids);
    }

    loop {
        let character = all_character_positions.pop_front();
        match character {
            Option::Some(character) => {
                let mut is_dead = false;
                let mut j = 0;
                while j < dead_characters.len() {
                    if character.id == *dead_characters.at(j) {
                        is_dead = true;
                        break;
                    }
                    j += 1;
                };
                if !is_dead {
                    filtered_positions.append(character);
                    filtered_ids.append(character.id);
                }
            },
            Option::None => { break; }
        }
    };
    return (filtered_positions, filtered_ids);
}


fn check_is_valid_move(v: IVec2, max_distance_per_sub_move: u32) -> bool {
    if (v.x * v.x)
        + (v.y * v.y) <= max_distance_per_sub_move.into() * max_distance_per_sub_move.into() {
        return true;
    } else {
        return false;
    }
}

fn get_next_shot(ref moves: TurnMove) -> (u32, u32) {
    let mut result = (0, 0);

    //start out of bounds
    let mut current_lowest_step = moves.actions[0].shots.len() + 1;
    let mut current_lowest_action = moves.actions.len() + 1;

    let mut i = 0;
    while i < moves.actions.len() {
        if moves.actions[i].shots.len() == 0 {
            i += 1;
            continue;
        }
        let next = moves.actions[i].shots[0].step;
        
        if next < current_lowest_step {
            current_lowest_step = next;
            current_lowest_action = i;
        }
        i += 1;
    }

    moves.actions[current_lowest_action].shots.pop_front();
    
    return (current_lowest_step, current_lowest_action);
}

