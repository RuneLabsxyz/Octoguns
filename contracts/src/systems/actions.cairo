use octoguns::types::{CharacterPosition, CharacterMove};
use octoguns::models::bullet::{Bullet, BulletTrait};

#[dojo::interface]
trait IActions {
    fn move(ref world: IWorldDispatcher, session_id: u32, moves: Array<CharacterMove>);
}

#[dojo::contract]
mod actions {
    use super::IActions;
    use octoguns::types::{Vec2, Action, CharacterMove, CharacterPosition};
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::character::{Character, Position};
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

            // TODO also get all the active character ids and iterate over them to remove the all_character_ids
            // from the other team 

            // Create an array to store initial positions
            // @Note initial_position struct: Array<CharacterPosition>
            // pub struct CharacterPosition {
            //     pub id: u32,
            //     pub x: u16,
            //     pub y: u16,
            //     pub max_steps: u32,
            //     pub current_step: u32,
            // }
            let mut initial_positions = get_character_positions(world, ref user_character_ids);
            let mut all_character_positions = get_character_positions(world, ref all_character_ids);

            let mut bullets = get_all_bullets(world, session_id);

            let mut step_count = 0;
            while step_count < 100_u8{
                let mut user_count = 0;
                moves = moves_clone.clone();
                let mut updated_positions = ArrayTrait::new();
                loop {

                    if user_count == initial_positions.len() {
                        break;
                    }
                    let character_move = moves.pop_front().unwrap(); 
                    

                    let mut character = *initial_positions.at(user_count);
                    println!("{}",character.id);
                    let is_owner = check_is_character_owner(world, character.id, player);
                    
                    assert!(is_owner, "Not piece owner");
                    // check character is out of moves
                    if character.current_step >= character.max_steps {
                        updated_positions.append(character);
                        user_count += 1;    
                        break;
                    }

                    // TODO Check if move is valid
                    //Get movement vector
                    let movement = *character_move.movement.at(user_count); 
                    let movement_x = movement.x;
                    let movement_y = movement.y;

                    //Checks if the move is not to big
                    let is_valid = check_is_valid_move(movement_x, movement_y);
                    if !is_valid {
                        updated_positions.append(character);
                        user_count += 1;
                        break;
                    }

                    // TODO Check if the move collides
                    let is_collision = false;
                    if !is_collision {
                        //Move character
                        character.coords.x = (character.coords.x + movement_x);
                        character.coords.y = (character.coords.y + movement_y);
                        character.current_step += 1;
                    }
                    updated_positions.append(character);

                    // Compute shot bullets
                    let mut next_bullet_shot = *character_move.actions.at(0);
                    if next_bullet_shot.step == step_count {
                        //Shoot
                        let bullet = shoot(world, next_bullet_shot, character, player);
                        bullets.append(bullet);
                    }
                    user_count += 1;
                };
                // Replace initial_positions with updated_positions
                initial_positions = updated_positions;

                // simulate Bullets
                let ( new_bullets, dead_characters ) = simulate_bullets(ref bullets, ref all_character_positions);
                
                // Update models in the world
                let (new_user_character, new_user_character_ids) = filter_out_dead_characters(world, initial_positions, dead_characters.clone());
                initial_positions = new_user_character;
                user_character_ids = new_user_character_ids;

                // Remove dead characters from all_character_ids
                let (new_all_character, new_all_character_ids) = filter_out_dead_characters(world, all_character_positions, dead_characters.clone());
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

            let bullet_ids = extract_bullet_ids(bullets);
            session_meta.next_turn();
            session_meta.set_new_characters(all_character_ids);
            session_meta.set_new_bullets(bullet_ids);
            
            set!(world, (session_meta, session));
        }
    }
}

