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
    use octoguns::lib::move_utils::helpers::{
        get_all_bullets, 
        filter_out_dead_characters, 
        check_is_valid_move, 
        get_next_shot, 
        shoot, 
        check_win, 
        update_positions
    };
    use octoguns::lib::move_utils::get_positions::{get_move_positions, get_rest_positions};
    use octoguns::lib::move_utils::simulate::{simulate_bullets};
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


            assert!(moves.actions.len().into() <= settings.actions && moves.actions.len() > 0, "Invalid number of actions");
            let player = get_caller_address();
            let mut session: Session = world.read_model(session_id);
            assert!(session.state != 1, "Game doesn't exist");
            assert!(session.state != 3, "Game over");
            assert!(session.state == 2, "Game not active");

            let mut session_meta: SessionMeta = world.read_model(session_id);
            let mut map: Map = world.read_model(session.map_id);

            let mut updated_bullet_ids = ArrayTrait::new();

            let mut action_positions: Array<Array<CharacterPosition>> = get_move_positions(ref world, ref moves);

            let mut all_positions = ArrayTrait::new();
            let mut opp_positions = ArrayTrait::new();
   
            //GET ALL POSITIONS, MAYBE SEPARTE BY ACTION FOR PLAYER CHARACTGERS?

             match session_meta.turn_count % 2 {
                 0 => {
                    assert!(player == session.player1, "not turn player, 1s turn");
                    let (mut all_positions, mut opp_positions) = get_rest_positions(ref world, ref session_meta, 1);

                 },
                 1 => {
                    assert!(player == session.player2, "not turn player, 2s turn");
                    let (mut all_positions, mut opp_positions) = get_rest_positions(ref world, ref session_meta, 2);

                 },
                 _ => { panic!("???"); }
             }

            let mut bullets = get_all_bullets(world, session_id);

            //start out of bounds so never reached in loop if no shots
            let max_steps = settings.sub_moves;

            let (next_shot, next_shot_action, next_shot_shot) = get_next_shot(ref moves);

            let total_steps = max_steps * session_meta.turn_count;
            let mut sub_move_index = 0;

            while sub_move_index < max_steps {
                let step = sub_move_index + total_steps;

                if sub_move_index == next_shot.into() {
                    shoot(ref world, ref action_positions[next_shot_action], next_shot_shot);
                    let (next_shot_step, next_shot_action, next_shot_shot) = get_next_shot(ref moves);

                }

                // Loop through positions and update the grid

                let (mut grid1, mut grid2, mut grid3) = set_grid_bits_from_positions(ref all_positions);

                //advance bullets + check collisions
                let (new_bullets, new_bullet_ids, dead_characters) = simulate_bullets(
                    ref bullets, ref opp_positions, ref map, step, settings.bullet_steps, ref grid1, ref grid2, ref grid3
                );
                bullets = new_bullets;
                updated_bullet_ids = new_bullet_ids;

                let (new_positions, mut filtered_character_ids) = filter_out_dead_characters(
                    ref all_positions, dead_characters
                );

                all_positions = new_positions;

                let res = check_win(ref filtered_character_ids, ref opp_positions);

                //if win, set session state to 3 and break
                if res {
                    session.state = 3;
                    break;
                }

                update_positions(ref positions, ref moves);
                
                // positions = array![player_position, opp_position];

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
