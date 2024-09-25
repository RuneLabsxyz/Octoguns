use octoguns::types::{TurnMove};
use octoguns::models::bullet::{Bullet, BulletTrait};

#[dojo::interface]
trait IActions {
    fn move(ref world: IWorldDispatcher, session_id: u32, moves: Array<TurnMove>);
}

#[dojo::contract]
mod actions {
    use super::IActions;
    use octoguns::types::{Vec2, IVec2, Shot, TurnMove};
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait, SessionMetaStore};
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::lib::helpers::{get_all_bullets, filter_out_dead_characters, apply_submoves};
    use octoguns::lib::simulate::{simulate_bullets};
    use starknet::{ContractAddress, get_caller_address};
    use core::cmp::{max, min};


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn move(ref world: IWorldDispatcher, session_id: u32, mut moves: Array<TurnMove>) {
            assert!(moves.len() == 3, "Invalid number of turn moves");
            
            let player = get_caller_address();
            let mut session = get!(world, session_id, (Session));

            assert!(session.state != 1, "Game doesn't exist");
            assert!(session.state != 3, "Game over");
            assert!(session.state == 2, "Game not active");

            let mut m1 = moves.pop_front().unwrap();
            let mut m2 = moves.pop_front().unwrap();
            let mut m3 = moves.pop_front().unwrap();

            let map = get!(world, session_id, (Map));

            let session_meta = SessionMetaStore::get(world, session_id);
            let SessionMeta {session_id, turn_count, p1_characters, p2_characters, bullets} = session_meta;

            let mut updated_bullet_ids = array![];

            let mut player_characters = array![].span();
            let mut opp_characters = array![].span();


            match turn_count % 2 {
                0 => {
                    assert!(player == session.player1, "not turn player, 1s turn");
                    player_characters = p1_characters.span();
                    opp_characters = p2_characters.span();
                },
                1 => {
                    assert!(player == session.player2, "not turn player, 2s turn");
                    player_characters = p2_characters.span();
                    opp_characters = p1_characters.span();
                },
                _ => {
                    panic!("???");
                }
            }
            //each sub array are the positions of the characters that are affected by the same move
            let mut all_positions: Array<CharacterPosition> = array![];

            let mut m1_positions = array![];
            let mut m2_positions = array![];
            let mut m3_positions = array![];

            let mut m1_next_index = 0;
            let mut m2_next_index = 0;
            let mut m3_next_index = 0;
            let mut m1_next_id = *m1.characters.at(0);
            let mut m2_next_id = *m2.characters.at(0);
            let mut m3_next_id = *m3.characters.at(0);

            //get all player characters
            loop {
                let maybe_player_character_id = player_characters.pop_front();
                match maybe_player_character_id{
                    Option::Some(id) => {
                        let position = get!(world, *id, (CharacterPosition));
                        assert!(position.status == 1, "character dead");
                        if *id == m1_next_id {
                            m1_positions.append(position);
                            m1_next_index += 1; 
                            m1_next_id = *m1.characters.at(m1_next_index);
                        }
                        if *id == m2_next_id {
                            m2_positions.append(position);
                            m2_next_index += 1;
                            m2_next_id = *m2.characters.at(m2_next_index);
                        }
                        if *id == m3_next_id {
                            m3_positions.append(position);
                            m3_next_index += 1;
                            m3_next_id = *m3.characters.at(m3_next_index);
                        }
                        
                        all_positions.append(position);
                    },
                    Option::None => {
                        break;
                    }
                }
            };

            loop {
                let opp_character_id = opp_characters.pop_front();
                match opp_character_id {
                    Option::Some(id) => {
                        let position = get!(world, *id, (CharacterPosition));
                        if position.status == 1 {
                            all_positions.append(position);
                        }
                    },
                    Option::None => {
                        break;
                    }
                }
            };

            let mut bullets = get_all_bullets(world, session_id);
            
            //start out of bounds so never reached in loop
            let mut next_shot_t1 = 101;
            let mut next_shot_t2 = 101;
            let mut next_shot_t3 = 101;
            if m1.shots.len() > 0 {
                next_shot_t1 = m1.shots.pop_front().unwrap().step;
            }
            if m2.shots.len() > 0 {
                next_shot_t2 = m2.shots.pop_front().unwrap().step;
            }
            if m3.shots.len() > 0 {
                next_shot_t3 = m3.shots.pop_front().unwrap().step;
            }

            let mut sub_move_index = 0;

            while sub_move_index < 100 {
                let step: u32 = turn_count * 100 + sub_move_index;

                if sub_move_index == next_shot_t1.into() {
                    //check for shots
                    let mut shot = m1.shots.pop_front().unwrap();
                    let mut m1_positions_clone = m1_positions.clone();
                    loop {
                        let character = m1_positions_clone.pop_front();
                        match character {
                            Option::Some(character) => {
                                let bullet = BulletTrait::new(
                                    world.uuid(), 
                                    Vec2 {x: character.coords.x, y: character.coords.y}, 
                                    shot.angle, 
                                    character.id,
                                    step
                                );
                                bullets.append(bullet);
                                set!(world, (bullet));
                            },
                            Option::None => {
                                break;
                            }
                        }
                    };           
                }

                if sub_move_index == next_shot_t2.into() {
                    let mut shot = m2.shots.pop_front().unwrap();
                    let mut m2_positions_clone = m2_positions.clone();
                    loop {
                        let character = m2_positions_clone.pop_front();
                        match character {
                            Option::Some(character) => {
                                let bullet = BulletTrait::new(
                                    world.uuid(), 
                                    Vec2 {x: character.coords.x, y: character.coords.y}, 
                                    shot.angle, 
                                    character.id,
                                    step
                                );
                                bullets.append(bullet);
                                set!(world, (bullet));
                            },
                            Option::None => {
                                break;
                            }
                        }
                    };
                }

                if sub_move_index == next_shot_t3.into() {
                    let mut shot = m3.shots.pop_front().unwrap();
                    let mut m3_positions_clone = m3_positions.clone();
                    loop {
                        let character = m3_positions_clone.pop_front();
                        match character {
                            Option::Some(character) => {
                                let bullet = BulletTrait::new(
                                    world.uuid(), 
                                    Vec2 {x: character.coords.x, y: character.coords.y}, 
                                    shot.angle, 
                                    character.id,
                                    step
                                );
                                bullets.append(bullet);
                                set!(world, (bullet));
                            },
                            Option::None => {
                                break;
                            }
                        }
                    };
                }

                //apply moves
                let mut positions = array![];

                let mut new_m1_positions = apply_submoves(m1.sub_moves.pop_front().unwrap(), ref m1_positions, ref positions);
                let mut new_m2_positions = apply_submoves(m2.sub_moves.pop_front().unwrap(), ref m2_positions, ref positions);
                let mut new_m3_positions = apply_submoves(m3.sub_moves.pop_front().unwrap(), ref m3_positions, ref positions);

                m1_positions = new_m1_positions;
                m2_positions = new_m2_positions;
                m3_positions = new_m3_positions;

                let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref positions, @map, step);
                updated_bullet_ids = updated_bullets;
                //remove dead characters
                let (updated_positions, updated_ids) = filter_out_dead_characters(ref positions, dead_characters_ids);
                all_positions = updated_positions;
                
                sub_move_index+=1;

                //END MOVE LOOP
            };

            //set new positions
            loop { 
                let next_position = all_positions.pop_front();
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

            let new_session_meta = SessionMeta{
                session_id,
                turn_count: turn_count + 1,
                p1_characters: p1_characters,
                p2_characters: p2_characters,
                bullets: updated_bullet_ids
            };
            set!(world, (session, new_session_meta));


        }
    }

}

