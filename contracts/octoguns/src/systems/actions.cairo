use octoguns::types::{TurnMove};
use octoguns::models::bullet::{Bullet, BulletTrait};

#[starknet::interface]
trait IActions<T> {
    fn move(self: @T, session_id: u32, moves: TurnMove);
}

#[dojo::contract]
mod actions {
    use super::IActions;
    use octoguns::types::{Vec2, IVec2, Shot, TurnMove};
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait, SessionPrimitives};
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::models::turndata::{TurnData};
    use octoguns::lib::helpers::{get_all_bullets, filter_out_dead_characters, check_is_valid_move};
    use octoguns::lib::simulate::{simulate_bullets};
    use starknet::{ContractAddress, get_caller_address};
    use core::cmp::{max, min};
    use octoguns::lib::grid::{convert_coords_to_grid_indices, set_grid_bits_from_positions};
    use octoguns::models::global::{Global, GlobalTrait, GlobalImpl};
    use octoguns::consts::{GLOBAL_KEY};

    use dojo::model::{ModelStorage, ModelValueStorage, Model};

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn move(self: @ContractState, session_id: u32, mut moves: TurnMove) {
            let mut world = self.world(@"octoguns");

            let mut global: Global = world.read_model(GLOBAL_KEY);
            let session_primitives: SessionPrimitives = world.read_model(session_id);
            let settings = session_primitives.settings;


            assert!(moves.actions.len() <= settings.actions && moves.actions.len() > 0, "Invalid number of actions");
            let player = get_caller_address();
            let mut session: Session = world.read_model(session_id);
            assert!(session.state != 1, "Game doesn't exist");
            assert!(session.state != 3, "Game over");
            assert!(session.state == 2, "Game not active");


            let mut session_meta: SessionMeta = world.read_model(session_id);
            let mut map: Map = world.read_model(session.map_id);

            let mut updated_bullet_ids = ArrayTrait::new();

            let mut player_character_id = 0;
            let mut opp_character_id = 0;

            match session_meta.turn_count % 2 {
                0 => {
                    assert!(player == session.player1, "not turn player, 1s turn");
                    player_character_id = session_meta.p1_character;
                    opp_character_id = session_meta.p2_character;
                },
                1 => {
                    assert!(player == session.player2, "not turn player, 2s turn");
                    player_character_id = session_meta.p2_character;
                    opp_character_id = session_meta.p1_character;
                },
                _ => { panic!("???"); }
            }

            let mut player_position: CharacterPosition = world.read_model(player_character_id);
            let mut opp_position: CharacterPosition = world.read_model(opp_character_id);
            let mut positions = array![player_position, opp_position];

            let mut bullets = get_all_bullets(world, session_id);

            //start out of bounds so never reached in loop if no shots

            let mut next_shot = max_steps + 1;

            let mut (next_shot_step, next_shot_action) = get_next_shot(moves);

            let total_steps = max_steps * session_meta.turn_count;
            let mut sub_move_index = 0;

            while sub_move_index < max_steps {
                let step = sub_move_index + total_steps;

                if sub_move_index == next_shot.into() {
                    let shot = moves.shots.pop_front();
                    match shot {
                        Option::Some(s) => {
                            let bullet = BulletTrait::new(
                                global.uuid(),
                                Vec2 { x: player_position.coords.x, y: player_position.coords.y },
                                s.angle,
                                player_character_id,
                                step.try_into().unwrap(),
                                settings.bullet_speed,
                                settings.bullet_sub_steps,
                            );
                            bullets.append(bullet);
                            world.write_model(@bullet);

                            if moves.shots.len() > 0 {
                                next_shot = *moves.shots.at(0).step;
                            }
                        },
                        Option::None => { //shouldn't reach
                        }
                    }
                }

                // Loop through positions and update the grid

                let (mut grid1, mut grid2, mut grid3) = set_grid_bits_from_positions(ref positions);

                //advance bullets + check collisions
                let (new_bullets, new_bullet_ids, dead_characters) = simulate_bullets(
                    ref bullets, ref positions, ref map, step, settings.bullet_sub_steps, ref grid1, ref grid2, ref grid3
                );
                bullets = new_bullets;
                updated_bullet_ids = new_bullet_ids;

                let (new_positions, mut filtered_character_ids) = filter_out_dead_characters(
                    ref positions, dead_characters
                );

                positions = new_positions;

                //get next sub_move
                //TODO: FIX FOR MULTIPLE CHARACTERS
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
                positions = array![player_position, opp_position];

                sub_move_index += 1;
                //END MOVE LOOP
            };
            //set new positions
            loop {
                let next_position = positions.pop_front();
                match next_position {
                    Option::Some(pos) => {
                        world.write_model(@pos);
                    },
                    Option::None => { break; }
                }
            };

            session_meta.turn_count += 1;
            session_meta.bullets = updated_bullet_ids;

            world.write_model(@session);
            world.write_model(@session_meta);
            world.write_model(@global);
        }
    }
}