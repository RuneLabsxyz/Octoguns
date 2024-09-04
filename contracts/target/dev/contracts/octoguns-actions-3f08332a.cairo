#[starknet::contract]
pub mod actions {
    use dojo::world;
    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;
    use dojo::world::IWorldProvider;
    use dojo::contract::IContract;
    use starknet::storage::{
        StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess
    };

    component!(
        path: dojo::contract::upgradeable::upgradeable,
        storage: upgradeable,
        event: UpgradeableEvent
    );

    #[abi(embed_v0)]
    pub impl ContractImpl of IContract<ContractState> {
        fn contract_name(self: @ContractState) -> ByteArray {
            "actions"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "octoguns"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "octoguns-actions"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            2086192618380495284091910654139796563008957181282529006110721547110208160990
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            1924336117031027642112813060054040969607345629178792935276372212332421167173
        }

        fn selector(self: @ContractState) -> felt252 {
            1781887335371945274907145552582075156012951674795577023961116862906090943850
        }
    }

    #[abi(embed_v0)]
    impl WorldProviderImpl of IWorldProvider<ContractState> {
        fn world(self: @ContractState) -> IWorldDispatcher {
            self.world_dispatcher.read()
        }
    }

    #[abi(embed_v0)]
    impl UpgradableImpl =
        dojo::contract::upgradeable::upgradeable::UpgradableImpl<ContractState>;

    use super::IActions;
    use octoguns::types::{Vec2, Shot, TurnMove};
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
        fn move(ref self: ContractState, session_id: u32, mut moves: TurnMove) {
            let world = self.world_dispatcher.read();
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
                    assert!(player == session.player1, "not turn player");
                    player_character_id = session_meta.p1_character;
                    opp_character_id = session_meta.p2_character;
                },
                1 => {
                    assert!(player == session.player2, "not turn player");
                    player_character_id = session_meta.p2_character;
                    opp_character_id = session_meta.p1_character;
                },
                _ => { panic!("???"); }
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
                        if !check_is_valid_move(vec) {
                            vec.x = 0;
                            vec.y = 0;
                        }
                        //apply move
                        if vec.xdir {
                            player_position
                                .coords
                                .x = max(10_000, player_position.coords.x + vec.x);
                        } else {
                            vec.x = min(vec.x, player_position.coords.x);
                            player_position.coords.x -= vec.x;
                        }
                        if vec.xdir {
                            player_position
                                .coords
                                .y = max(10_000, player_position.coords.y + vec.y);
                        } else {
                            vec.x = min(vec.y, player_position.coords.y);
                            player_position.coords.y -= vec.y;
                        }
                    },
                    Option::None => { break; }
                }

                if sub_move_index == next_shot {
                    let shot = moves.shots.pop_front();
                    match shot {
                        Option::Some(s) => {
                            bullets
                                .append(
                                    BulletTrait::new(
                                        world.uuid(),
                                        Vec2 {
                                            x: player_position.coords.x, y: player_position.coords.y
                                        },
                                        s.angle,
                                        player
                                    )
                                );
                            if moves.shots.len() > 0 {
                                next_shot = *moves.shots.at(0).step;
                            }
                        },
                        Option::None => {//shouldn't reach
                        }
                    }
                }

                //advance bullets + check collisions
                let (bullets, dead_characters) = simulate_bullets(ref bullets, ref positions);
                let (positions, mut filtered_character_ids) = filter_out_dead_characters(
                    ref positions, dead_characters
                );

                if filtered_character_ids.len() < 2 {
                    match filtered_character_ids.len() {
                        0 => {//draw
                        },
                        1 => {
                            let winner = filtered_character_ids.pop_front().unwrap();
                            if session_meta.p1_character == winner {//p1 wins
                            }
                            if session_meta.p2_character == winner {//p2 wins
                            }
                        },
                        _ => {}
                    }
                    break;
                }

                // in real game set all_positions and all_ids to filtered ones
                // not necessary in 1v1
                sub_move_index += 1;
                //END MOVE LOOP
            };

            //set new bullet positions bullets
            loop {
                let next_bullet = bullets.pop_front();
                match next_bullet {
                    Option::Some(bullet) => { set!(world, (bullet)); },
                    Option::None => { break; }
                }
            };

            //set new positions
            loop {
                let next_position = positions.pop_front();
                match next_position {
                    Option::Some(pos) => { set!(world, (pos)); },
                    Option::None => { break; }
                }
            };
        }
    }
    #[starknet::interface]
    pub trait IDojoInit<ContractState> {
        fn dojo_init(self: @ContractState);
    }

    #[abi(embed_v0)]
    pub impl IDojoInitImpl of IDojoInit<ContractState> {
        fn dojo_init(self: @ContractState) {
            if starknet::get_caller_address() != self.world().contract_address {
                core::panics::panic_with_byte_array(
                    @format!(
                        "Only the world can init contract `{}`, but caller is `{:?}`",
                        self.tag(),
                        starknet::get_caller_address(),
                    )
                );
            }
        }
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        UpgradeableEvent: dojo::contract::upgradeable::upgradeable::Event,
    }

    #[storage]
    struct Storage {
        world_dispatcher: IWorldDispatcher,
        #[substorage(v0)]
        upgradeable: dojo::contract::upgradeable::upgradeable::Storage,
    }
}

