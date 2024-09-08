use octoguns::types::{TurnMove};
use octoguns::models::bullet::{Bullet, BulletTrait};

#[dojo::interface]
trait IActions {
    fn move(ref world: IWorldDispatcher, session_id: u32, moves: TurnMove);
}

#[dojo::contract]
mod actions {
    use super::IActions;
    use octoguns::types::{Vec2, IVec2, Shot, TurnMove};
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::lib::helpers::{get_all_bullets, filter_out_dead_characters, check_is_valid_move};
    use octoguns::lib::simulate::{simulate_bullets};
    use octoguns::lib::shoot::{shoot};
    use starknet::{ContractAddress, get_caller_address};
    use core::cmp::{max, min};

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn move(ref world: IWorldDispatcher, session_id: u32, mut moves: TurnMove) {
            assert!(moves.sub_moves.len() <= 100, "Invalid number of moves");
            assert!(moves.shots.len() <= 3, "Invalid number of shots");
            let player = get_caller_address();
            let mut session = get!(world, session_id, (Session));
            assert!(session.state == 2, "Game not started");
            let mut session_meta = get!(world, session_id, (SessionMeta));

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
                _ => {
                    panic!("???");
                }
            }

            let mut player_position = get!(world, session_meta.p1_character, (CharacterPosition));
            let mut opp_position = get!(world, session_meta.p2_character, (CharacterPosition));
            let mut positions = array![player_position, opp_position];


            // +100 +100 to avoid underflow

            let mut bullets = get_all_bullets(world, session_id);
            
            //start out of bounds so never reached in loop
            let mut next_shot = 101;
            if moves.shots.len() > 0 {
                next_shot = (*moves.shots.at(0)).step;
            }

            let mut sub_move_index = 0;

            while sub_move_index < 100 {

                //get next sub_move
                let mut sub_move = moves.sub_moves.pop_front();
                match sub_move {
                    Option::Some(mut vec) => {
                        //check move valid 
                        if !check_is_valid_move(vec){
                            vec = IVec2 {x: 0, y: 0, xdir: true, ydir: true};
                        }
                        //apply move
                        if vec.xdir{
                            player_position.coords.x = max(10_000, player_position.coords.x + vec.x); 
                        }
                        else {
                            vec.x = min( vec.x, player_position.coords.x );
                            player_position.coords.x -= vec.x;
                        }
                        if vec.xdir{
                            player_position.coords.y = max(10_000, player_position.coords.y + vec.y); 
                        }
                        else {
                            vec.x = min( vec.y, player_position.coords.y );
                            player_position.coords.y -= vec.y;
                        }


                    },
                    Option::None => {
                        break;
                    }

                }
                positions = array![player_position, opp_position];


                if sub_move_index == next_shot {
                    let shot = moves.shots.pop_front();
                    match shot {
                        Option::Some(s) => {
                            bullets.append(BulletTrait::new(
                                                world.uuid(), 
                                                Vec2 {x: player_position.coords.x, y: player_position.coords.y}, 
                                                s.angle, 
                                                player
                            ));
                            if moves.shots.len() > 0 {
                                next_shot = *moves.shots.at(0).step;
                            }
                        },
                        Option::None => {
                            //shouldn't reach
                        }

                    }
                }

                //advance bullets + check collisions
                let (new_bullets, dead_characters) = simulate_bullets(ref bullets, ref positions);
                bullets = new_bullets;
                let (new_positions, mut filtered_character_ids) = filter_out_dead_characters(ref positions, dead_characters);
                positions = new_positions;

                if filtered_character_ids.len() < 2 {
                    match filtered_character_ids.len() {
                        0 => {
                            //draw
                        },
                        1 => {
                            let winner = filtered_character_ids.pop_front().unwrap();
                            if session_meta.p1_character == winner {
                                //p1 wins
                            }
                            if session_meta.p2_character == winner {
                                //p2 wins
                            }
                        },
                        _ => {
                            
                        }
                    }
                    break;
                }

                // in real game set all_positions and all_ids to filtered ones
                // not necessary in 1v1
                sub_move_index+=1;
                //END MOVE LOOP
            };

            //set new bullet positions bullets
            loop {
                let next_bullet = bullets.pop_front();
                match next_bullet {
                    Option::Some(bullet) => {
                        set!(world, (bullet));
                    },
                    Option::None => {
                        break;
                    }
                }
            };

            //set new positions
            loop { 
                let next_position = positions.pop_front();
                match next_position {
                    Option::Some(pos) => {
                        println!("setting new positions: x: {} y: {}" , pos.coords.x, pos.coords.y);
                        set!(world, (pos));
                    },
                    Option::None => {
                        break;
                    }
                }
            };


        }
    }
}

