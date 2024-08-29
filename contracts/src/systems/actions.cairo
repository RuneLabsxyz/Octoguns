use octoguns::types::{CharacterMove};
use octoguns::models::bullet::{Bullet, BulletTrait};

#[dojo::interface]
trait IActions {
    fn move(ref world: IWorldDispatcher, session_id: u32, moves: Array<CharacterMove>);
}

#[dojo::contract]
mod actions {
    use super::IActions;
    use octoguns::types::{Vec2, Action, CharacterMove};
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::character::{Character, CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::lib::helpers::{get_character_ids, get_character_positions, get_all_bullets, check_is_character_owner, filter_out_dead_characters, extract_bullet_ids, check_win, check_is_valid_move};
    use octoguns::lib::simulate::{simulate_bullets};
    use octoguns::lib::shoot::{shoot};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn move(ref world: IWorldDispatcher, session_id: u32, mut moves: Array<CharacterMove>) {
            assert(moves.len() <= 3, 'Invalid number of moves');
            let player = get_caller_address();
            let mut session = get!(world, session_id, (Session));
            assert!(session.state == 2, "Game not started");
            let mut session_meta = get!(world, session_id, (SessionMeta));
            match session_meta.turn_count % 2 {
                0 => {
                    assert!(player == session.player2, "not turn player");
                },
                1 => {
                    assert!(player == session.player1, "not turn player");
                },
                _ => {

                }
            }

            // Collect all unique character IDs from all moves
            let mut moves_clone = moves.clone();
            let mut user_character_ids = get_character_ids(@moves);
            let mut all_character_ids = session_meta.characters.clone();


            let mut user_positions = get_character_positions(world, ref user_character_ids);
            let mut all_character_positions = get_character_positions(world, ref all_character_ids);

            let mut bullets = get_all_bullets(world, session_id);

            let mut updated_positions = ArrayTrait::new();

            // Checks working until here

            let mut step_count = 0;
            while step_count < 100_u8{
                let mut user_index = 0;
                moves = moves_clone.clone();
                loop {

                    if user_index == user_positions.len() {
                        break;
                    }
                    let character_move = moves.pop_front().unwrap(); 
                    

                    let mut character = *user_positions.at(user_index);
                    println!("Getting character id");
                    println!("{}",character.id);
                    let is_owner = check_is_character_owner(world, character.id, player);
                    
                    assert!(is_owner, "Not piece owner");
                    // check character is out of moves
                    if character.current_step >= character.max_steps {
                        updated_positions.append(character);
                        user_index += 1;    
                        break;
                    }

                    // TODO Check if move is valid
                    //Get movement vector
                    let movement = *character_move.movement.at(user_index); 
                    let movement_x = movement.x;
                    let movement_y = movement.y;
                    

                    println!("Extracted movement");
                    println!("Movement x: {}", movement_x);
                    println!("Movement y: {}", movement_y);
                    //Checks if the move is not to big
                    let is_valid = check_is_valid_move(movement_x, movement_y);
                    if !is_valid {
                        println!("Invalid move");
                        updated_positions.append(character);
                        user_index += 1;
                    }

                    println!("Valid move");

                    // TODO Check if the move collides
                    let is_collision = false;
                    if !is_collision {
                        //Move character
                        let mut new_x = ((character.coords.x + 100).try_into().unwrap() + movement_x);
                        let mut new_y = ((character.coords.y + 100).try_into().unwrap() + movement_y);
                        if new_x < 100 {
                            new_x = 0;
                        }
                        else {
                            new_x -= 100;
                        }
                        if new_y < 100 {
                            new_y = 0;
                        }
                        else {
                            new_y -= 100;
                        }
                        character.coords.x = new_x.try_into().unwrap();
                        character.coords.y = new_y.try_into().unwrap();
                        
                        
                        character.current_step += 1;
                        println!("No collision");
                        println!("Character moved");
                    }
                    updated_positions.append(character);

                    // Compute shot bullets
                    let mut next_bullet_shot = *character_move.actions.at(0);
                    if next_bullet_shot.step == step_count {
                        //Shoot
                        let bullet = shoot(world, next_bullet_shot, character, player);
                        bullets.append(bullet);
                    }

                    println!("Bullet shot");
                    user_index += 1;
                };

                // simulate Bullets
                let ( new_bullets, dead_characters ) = simulate_bullets(ref bullets, ref all_character_positions);
                
                // Update models in the world
                let (new_user_character, new_user_character_ids) = filter_out_dead_characters(world, @all_character_positions, dead_characters.clone());


                // Remove dead characters from all_character_ids
                let (new_all_character, new_all_character_ids) = filter_out_dead_characters(world, @all_character_positions, dead_characters.clone());
                all_character_positions = new_all_character;
                all_character_ids = new_all_character_ids;

                bullets = new_bullets;

                let is_win = check_win( ref user_character_ids, ref all_character_ids);
                if is_win == 1 {
                    // Player 1 wins
                    session.state = 3;
                    break;
                } else if is_win == 2 {
                    // Player 2 wins
                    session.state = 4;
                    break;
                }
                


                step_count += 1;
            };

            let bullet_ids = extract_bullet_ids(@bullets);
            session_meta.next_turn();
            session_meta.set_new_characters(all_character_ids);
            session_meta.set_new_bullets(bullet_ids);
            let b_clone = bullets.clone();
            let p_clone = updated_positions.clone();

            let mut index = 0;
            loop {
                if index < bullets.len() {
                    set!(world, (*b_clone.at(index)));
                }
                if index < updated_positions.len() {
                    set!(world, (*p_clone.at(index)));
                }
                if index >= bullets.len() && index>= updated_positions.len() {
                    break;
                }
                index += 1;
            };
            
            set!(world, (session_meta, session));
        }
    }
}

