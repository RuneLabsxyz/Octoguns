use octoguns::types::{TurnMove};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait, CharacterModel};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::sessions::{SessionMeta};
use octoguns::types::{IVec2, Vec2,Shot};
use starknet::{ContractAddress, get_caller_address};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use octoguns::consts::MOVE_SPEED;
use core::cmp::{min};

fn get_all_bullets(world: IWorldDispatcher, session_id: u32) -> Array<Bullet> {
    let mut all_live_bullets: Array<Bullet> = ArrayTrait::new();
    let session_meta = get!(world, session_id, (SessionMeta));
    let bullets = session_meta.bullets; //  type: array<u32>

    let mut i = 0;
    if bullets.len() == 0 {
        return all_live_bullets;
    }

    while i < bullets.len() {
        let bullet_id = *bullets.at(i);
        let bullet = get!(world, bullet_id, (Bullet));

        all_live_bullets.append(bullet);
        i += 1;
    };

    return all_live_bullets;
}

fn apply_submoves(move_vec: IVec2, ref move_positions: Array<CharacterPosition>, ref all_positions: Array<CharacterPosition>) -> Array<CharacterPosition> {
    let mut new_positions: Array<CharacterPosition> = ArrayTrait::new();
    let mut i = 0;
    let mut vec = move_vec;

    if !check_is_valid_move(vec){
        let vec = IVec2 {x: 0, y: 0, xdir: true, ydir: true};
    }
    let mut positions = move_positions.clone();
    loop {
        let mut position = positions.pop_front();
        match position {
            Option::Some(mut pos) => {
                //apply move
                if vec.xdir{
                    pos.coords.x = min(100_000, pos.coords.x + vec.x); 
                }
                else {
                    vec.x = min( vec.x, pos.coords.x );
                    pos.coords.x -= vec.x;
                }
                if vec.ydir{
                    pos.coords.y = min(100_000, pos.coords.y + vec.y); 

                }
                else {
                    vec.y = min( vec.y, pos.coords.y );
                    pos.coords.y -= vec.y;
                }
                all_positions.append(pos);
                new_positions.append(pos);
            },
            Option::None => { break; }
        }
    };
    return new_positions;
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
                        println!("character {} is dead", character.id);
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

fn check_is_valid_move(v:IVec2) -> bool {
    if (v.x*v.x) + (v.y*v.y) <= MOVE_SPEED*MOVE_SPEED {
        return true;
    }
    else {
        println!("invalid move");
        return false;
    }
}

