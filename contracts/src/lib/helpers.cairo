
use octoguns::types::{TurnMove};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait, CharacterModel};
use octoguns::models::bullet::{Bullet};
use octoguns::models::sessions::{SessionMeta};
use octoguns::types::IVec2;
use starknet::{ContractAddress, get_caller_address};
use dojo::world::IWorldDispatcher;

fn get_all_bullets(world: IWorldDispatcher, session_id: u32) -> Array<Bullet> {
    let mut all_live_bullets: Array<Bullet> = ArrayTrait::new();
    let session_meta = get!(world, session_id, (SessionMeta));
    let bullets = session_meta.bullets; //  type: array<u32>
    
    let mut i =0;
    while i < bullets.len() {
        let bullet_id = *bullets.at(i);
        let bullet = get!(world, bullet_id, (Bullet));

        all_live_bullets.append(bullet);
        i+=1;
    };

    return all_live_bullets;
}


fn filter_out_dead_characters(ref all_character_positions: Array<CharacterPosition>, dead_characters: Array<u32>) -> (Array<CharacterPosition>, Array<u32>) {
    let mut filtered_positions: Array<CharacterPosition> = ArrayTrait::new();
    let mut filtered_ids: Array<u32> = ArrayTrait::new();
    let mut i = 0;
    while i < all_character_positions.len() {

        let character = *all_character_positions.at(i);
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
        i += 1;
    };
    return (filtered_positions, filtered_ids);
}


fn check_is_valid_move(v:IVec2) -> bool {
    let max_user_speed: u32 = 100;
    if (v.x*v.x) + (v.y*v.y) <= max_user_speed* max_user_speed {
        return true;
    }
    return false;
}