#[cfg(test)]
mod tests {
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::model::{Model, ModelTest, ModelIndex, ModelEntityTest};
    // import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    use starknet::testing::{set_contract_address};
    use starknet::{ContractAddress, contract_address_const};
    // import test utils
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait, character_model, character_position};
    use octoguns::models::map::{Map, MapObjects, map, map_objects};
    use octoguns::models::sessions::{Session, session, SessionMeta, session_meta};
    use octoguns::models::bullet::{Bullet, bullet, BulletTrait};
    use octoguns::models::global::{Global, global};
    use octoguns::types::{TurnMove, Vec2, IVec2, Shot};

    use octoguns::systems::start::{start, IStartDispatcher, IStartDispatcherTrait}; 
    use octoguns::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use octoguns::systems::spawn::{spawn, ISpawnDispatcher, ISpawnDispatcherTrait};

    fn setup() -> ( IWorldDispatcher, 
                    IStartDispatcher, 
                    IActionsDispatcher,
                    ISpawnDispatcher) {

        let world = spawn_test_world!(["octoguns"]);


        // deploy systems contract
        let actions_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let spawn_address = world
            .deploy_contract('m', spawn::TEST_CLASS_HASH.try_into().unwrap());
        let start_address = world
            .deploy_contract('b', start::TEST_CLASS_HASH.try_into().unwrap());

        let actions_system = IActionsDispatcher { contract_address: actions_address };
        let spawn_system = ISpawnDispatcher { contract_address: spawn_address };
        let start_system = IStartDispatcher { contract_address: start_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), actions_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), spawn_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), start_address);

        (world, start_system, actions_system, spawn_system)
    }

    fn setup_game(start_system: IStartDispatcher, spawn_system: ISpawnDispatcher, p1: ContractAddress, p2: ContractAddress) -> u32 {
        set_contract_address(p1);
        let session_id = start_system.create();
        set_contract_address(p2);
        start_system.join(session_id);
        spawn_system.spawn(session_id);
        session_id
    }

    #[test]
    fn test_setup() {
        let (world, _, _, _) = setup();
    }

    #[test]
    fn test_game_setup() {
        let (world, start, _, spawn) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let session_meta = get!(world, session_id, (Session));
        assert_eq!(session_meta.player1, player1, "p1 is not set");
        assert_eq!(session_meta.player2, player2, "p2 is not set");

    }

    #[test]
    fn test_move() {
        let (world, start, actions, spawn) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let session = get!(world, session_id, (Session));
        let session_meta = get!(world, session_id, (SessionMeta));
        assert_eq!(session.player1, player1, "p1 is not set");
        assert_eq!(session.player2, player2, "p2 is not set");
        let mut i: u32 =0;
        let mut sub_moves = ArrayTrait::new();
        let position = get!(world, session_meta.p1_character, (CharacterPosition));
        while i< 100 {
            sub_moves.append( IVec2 { x: 50, y: 0, xdir: true, ydir: false });
            i+=1;
        };
        let character_id = session_meta.p1_character;
        set_contract_address(player1);
        let moves = TurnMove { sub_moves, shots: ArrayTrait::new() };
        actions.move(session_id, moves);
        let new_position = get!(world, session_meta.p1_character, (CharacterPosition));
        assert_eq!(new_position.coords.x, position.coords.x + 500, "character did not move");
    }


}