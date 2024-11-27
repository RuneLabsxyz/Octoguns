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

            //TODO: MAKE SURE THAT THIS ACTUALLY CHECKS THE CALLER IS THE TURN PLAYER
            let mut player_no = 0;
            if player == session.player1 {
                if session_meta.turn_count % 2 == 0 {
                    player_no = 1;
                }
                else {
                    panic!("not turn player, 2s turn");
                }
            }
            else if player == session.player2 {
                if session_meta.turn_count % 2 == 1 {
                    player_no = 2;
                }
                else {
                    panic!("not turn player, 1s turn");
                }
            }
            else {
                panic!("player");
            }

            let mut action_positions: Array<Array<CharacterPosition>> = get_move_positions(ref world, ref moves);

            let mut opp_positions = get_rest_positions(ref world, ref session_meta, player_no);

            let mut bullets = get_all_bullets(world, session_id);

            let max_steps = settings.sub_moves;

            let (mut next_shot, mut next_shot_action, mut next_shot_shot) = get_next_shot(ref moves);

            let total_steps = max_steps * session_meta.turn_count;
            let mut sub_move_index = 0;

             //MOVE LOOP
            while sub_move_index < max_steps {
                let step = sub_move_index + total_steps;

                if sub_move_index == next_shot.into() {
                    shoot(ref world, action_positions[next_shot_action], next_shot_shot, settings, step, ref bullets);
                    let (new_next_shot, new_next_shot_action, new_next_shot_shot) = get_next_shot(ref moves);
                    next_shot = new_next_shot;
                    next_shot_action = new_next_shot_action;
                    next_shot_shot = new_next_shot_shot;

                }

                // Loop through positions and update the grid

                let (mut grid1, mut grid2, mut grid3) = set_grid_bits_from_positions(@action_positions, @opp_positions);

                //advance bullets + check collisions
                let (new_bullets, new_bullet_ids, dead_characters) = simulate_bullets(
                    ref bullets, @action_positions, @opp_positions, ref map, step, settings.bullet_steps, ref grid1, ref grid2, ref grid3
                );

                bullets = new_bullets;
                updated_bullet_ids = new_bullet_ids;

                let (new_action_positions, new_opp_positions) = filter_out_dead_characters(
                    @action_positions, @opp_positions, dead_characters
                );

                action_positions = new_action_positions;
                opp_positions = new_opp_positions;

                let over = check_win(@action_positions, @opp_positions);

                //if win, set session state to 3 and break
                if over {
                    session.state = 3;
                    break;
                }

                let new_positions = update_positions(ref action_positions, ref moves, settings, step);
                action_positions = new_positions;
                // positions = array![player_position, opp_position];

                sub_move_index += 1;
                //END MOVE LOOP
            };

            //


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

            //TODO: UPDATE IDS IN SESSION META

            session_meta.turn_count += 1;
            session_meta.bullets = updated_bullet_ids;

            world.write_model(@session);
            world.write_model(@session_meta);
            world.write_model(@global);
        }
    }
}
