use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait, CharacterModel};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::sessions::{SessionMeta, Settings};
use octoguns::models::global::{Global, GlobalTrait};
use octoguns::types::{TurnMove, IVec2, Shot, Vec2};
use starknet::{ContractAddress, get_caller_address};
use dojo::world::WorldStorage;
use dojo::model::{ModelStorage, ModelValueStorage, Model};
use core::cmp::{min, max};

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
    move_positions: @Array<Array<CharacterPosition>>, opp_positions: @Array<CharacterPosition>, dead_characters: Array<u32>
) -> (Array<Array<CharacterPosition>>, Array<CharacterPosition>) {
    let mut filtered_move_positions: Array<Array<CharacterPosition>> = ArrayTrait::new();
    let mut filtered_opp_positions: Array<CharacterPosition> = ArrayTrait::new();

    if dead_characters.len() == 0 {
        return (move_positions.clone(), opp_positions.clone());
    }

    let mut i = 0;
    let mut j = 0;

    while i < move_positions.len() {
        let action_positions = move_positions[i];
        let mut filtered_action_positions: Array<CharacterPosition> = ArrayTrait::new();
        while j < action_positions.len() && dead_characters.len() > 0 {
            let position = *action_positions.at(j);
            let mut is_dead = false;
            let mut k = 0;
            while k < dead_characters.len() {
                if position.id == *dead_characters.at(k) {
                    is_dead = true;
                    break;
                }
                k += 1;
            };
            if !is_dead {
                filtered_action_positions.append(position);
            }
            j += 1;
        };
        filtered_move_positions.append(filtered_action_positions);
        i += 1;
    };
    i = 0;
    while i < opp_positions.len() {
        let position = *opp_positions.at(i);
        let mut is_dead = false;
        let mut k = 0;
        while k < dead_characters.len() {
            if position.id == *dead_characters.at(k) {
                is_dead = true;
                break;
            }
            k += 1;
        };
        if !is_dead {
            filtered_opp_positions.append(position);
        }
        i += 1;
    };
    return (filtered_move_positions, filtered_opp_positions);
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

fn shoot(ref world: WorldStorage, positions: @Array<CharacterPosition>, shot: Option<Shot>, settings: Settings, step: u32, ref bullets: Array<Bullet>) {
    let mut global: Global = world.read_model(0);

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
    world.write_model(@global);
    
}


fn check_win(player_positions: @Array<Array<CharacterPosition>>, opp_positions: @Array<CharacterPosition>) -> bool {
    //todo

    let mut player_lost = false;
    let mut opp_lost = false;
    let mut i = 0;
    while i < player_positions.len() {
        if player_positions[i].len() == 0 {
            player_lost = true;
            break;
        }
        i += 1;
    };

    if (opp_positions.len() == 0) {
        opp_lost = true;
    }

    if (player_lost || opp_lost) {
        return true;
    }
    return false;
    
}

fn update_positions(ref player_positions: Array<Array<CharacterPosition>>, ref moves: TurnMove, settings: Settings, index: u32) -> Array<Array<CharacterPosition>> {
    let mut new_positions: Array<Array<CharacterPosition>> = ArrayTrait::new();

        let mut i = 0;

        while i < moves.actions.len() {
            let action = moves.actions[i];
            let mut action_positions: Array<CharacterPosition> = ArrayTrait::new();

            let mut vec = *action.sub_moves[index];
            
            if !check_is_valid_move(vec, settings.sub_move_distance) {
                vec = IVec2 { x: 0, y: 0, xdir: true, ydir: true };
            }
            //apply move
            let mut j = 0;
            while j < player_positions.at(i).len() {
                let character_id = *player_positions.at(i).at(j).id;
                let mut player_position: CharacterPosition = world.read_model(character_id);

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
                j += 1;
                action_positions.append(player_position);
            };
            new_positions.append(action_positions);
            i+=1;
    };
    new_positions
    
}

fn flatten_positions(move_positions: @Array<Array<CharacterPosition>>, opp_positions: @Array<CharacterPosition>) -> Array<CharacterPosition> {
    let mut flat_positions: Array<CharacterPosition> = ArrayTrait::new();

    let mut i = 0;
    let mut j = 0;
    let mut k = 0;
    while i < move_positions.len() {
        let action_positions: @Array<CharacterPosition> = move_positions.at(i);
        j = 0;
        while j < action_positions.len() {
            let position = *action_positions.at(j);
            flat_positions.append(position);
            j += 1;

            if k < opp_positions.len() {
                let opp_position = *opp_positions.at(k);
                flat_positions.append(opp_position);
                k += 1;
            }
        };
        i += 1;
    };

    return flat_positions;
}


