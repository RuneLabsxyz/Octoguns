use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait, CharacterModel};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::sessions::{SessionMeta, Settings};
use octoguns::models::global::{Global, GlobalTrait};
use octoguns::types::{TurnMove, IVec2, Shot, Vec2};
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

fn get_next_shot(ref moves: TurnMove) -> (u32, u32, Option<Shot>) {
    //start out of bounds
    let mut current_lowest_step = moves.actions[0].shots.len() + 1;
    let mut current_lowest_action = moves.actions.len() + 1;

    let mut i = 0;
    while i < moves.actions.len() {
        if moves.actions[i].shots.len() == 0 {
            i += 1;
            continue;
        }
        let next = *moves.actions[i].shots[0].step;
        
        if next < current_lowest_step {
            current_lowest_step = next;
            current_lowest_action = i;
        }
        i += 1;
    };

    let mut shots: Array<Shot> = moves.actions[current_lowest_action].shots.clone();

    let shot = shots.pop_front();

    return (current_lowest_step, current_lowest_action, shot);
}

fn shoot(ref world: WorldStorage, ref positions: @Array<CharacterPosition>, shot: Option<Shot>, settings: Settings, step: u32, ref bullets: Array<Bullet>) {
    let mut global: Global = world.read_model(0);


    //TODO LOOP THROUGH ALL POSITIONS
    let mut i = 0;
    while i < positions.len() {
        let position = *positions[i];
        i += 1;
        match shot {
            Option::Some(s) => {
                let bullet = BulletTrait::new(
                    global.uuid(),
                    Vec2 { x: position.coords.x, y: position.coords.y },
                    s.angle,
                    position.id,
                    step.try_into().unwrap(),
                    settings.bullet_speed,
                    settings.bullet_steps,
                );
                bullets.append(bullet);
                world.write_model(@bullet);
            },
            Option::None => {}
        }
    };
    
}


fn check_win(player_characters: Array<u32>, opponent_characters: Array<u32>) {
    if filtered_character_ids.len() < 2 {
        match filtered_character_ids.len() {
            0 => {
                //draw
                break;
            },
            1 => {
                let winner = filtered_character_ids.pop_front().unwrap();
                if session_meta.p1_character == winner {
                    //p1 wins
                    session.state = 3;
                    session_meta.p2_character = 0;
                }
                if session_meta.p2_character == winner {
                    //p2 wins
                    session.state = 3;
                    session_meta.p1_character = 0;
                }
                break;
            },
            _ => {}
        }
    }
}

fn update_positions(ref player_positions: Array<CharacterPosition>, ref moves: TurnMove) {
    //TODO: LOOP TRHOUGH EACH ACTION
    match moves.sub_moves.pop_front() {
        Option::Some(mut vec) => {
            //check move valid
            if !check_is_valid_move(vec, settings.max_distance_per_sub_move) {
                vec = IVec2 { x: 0, y: 0, xdir: true, ydir: true };
            }
            //apply move

            if vec.xdir {
                player_position
                    .coords
                    .x =
                        min(
                            100_000,
                            player_position.coords.x + vec.x.try_into().unwrap()
                        );
            } else {
                vec.x = min(vec.x, player_position.coords.x.into());
                player_position.coords.x -= vec.x.try_into().unwrap();
            }
            if vec.ydir {
                player_position
                    .coords
                    .y =
                        min(
                            100_000,
                            player_position.coords.y + vec.y.try_into().unwrap()
                        );
            } else {
                vec.y = min(vec.y, player_position.coords.y.into());
                player_position.coords.y -= vec.y.try_into().unwrap();
            }
        },
        Option::None => {}
    }
}


