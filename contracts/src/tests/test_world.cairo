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
    use octoguns::models::map::{Map, MapTrait, map};
    use octoguns::models::sessions::{Session, session, SessionMeta, session_meta};
    use octoguns::models::bullet::{Bullet, bullet, BulletTrait};
    use octoguns::models::global::{Global, global};
    use octoguns::types::{TurnMove, Vec2, IVec2, Shot};
    use octoguns::consts::{GLOBAL_KEY};
    use octoguns::systems::start::{start, IStartDispatcher, IStartDispatcherTrait}; 
    use octoguns::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use octoguns::systems::spawn::{spawn, ISpawnDispatcher, ISpawnDispatcherTrait};
    use octoguns::systems::mapmaker::{mapmaker, IMapmakerDispatcher, IMapmakerDispatcherTrait};

    fn setup() -> ( IWorldDispatcher, 
                    IStartDispatcher, 
                    IActionsDispatcher,
                    ISpawnDispatcher,
                    IMapmakerDispatcher) {

        let world = spawn_test_world!(["octoguns"]);


        // deploy systems contract
        let actions_address = world
            .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
        let spawn_address = world
            .deploy_contract('m', spawn::TEST_CLASS_HASH.try_into().unwrap());
        let start_address = world
            .deploy_contract('b', start::TEST_CLASS_HASH.try_into().unwrap());
        let mapmaker_address = world
            .deploy_contract('m', mapmaker::TEST_CLASS_HASH.try_into().unwrap());

        let actions_system = IActionsDispatcher { contract_address: actions_address };
        let spawn_system = ISpawnDispatcher { contract_address: spawn_address };
        let start_system = IStartDispatcher { contract_address: start_address };
        let mapmaker_system = IMapmakerDispatcher { contract_address: mapmaker_address };

        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), actions_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), spawn_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), start_address);
        world.grant_writer(dojo::utils::bytearray_hash(@"octoguns"), mapmaker_address);

        mapmaker_system.default_map();

        (world, start_system, actions_system, spawn_system, mapmaker_system)
    }

    fn setup_game(start_system: IStartDispatcher, spawn_system: ISpawnDispatcher, p1: ContractAddress, p2: ContractAddress) -> u32 {
        set_contract_address(p1);
        let session_id = start_system.create(0);
        set_contract_address(p2);
        start_system.join(session_id);
        spawn_system.spawn(session_id);
        session_id
    }

    #[test]
    fn test_setup() {
        let (world, _, _, _, _) = setup();
    }

    #[test]
    fn test_game_setup() {
        let (world, start, _, spawn, _) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let session = get!(world, session_id, (Session));
        assert_eq!(session.player1, player1, "p1 is not set");
        assert_eq!(session.player2, player2, "p2 is not set");

    }

    #[test]
    #[ignore]
    fn test_move() {
        let (world, start, actions, spawn, _) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let session = get!(world, session_id, (Session));
        let session_meta = get!(world, session_id, (SessionMeta));
        let position = get!(world, session.player1, (CharacterPosition));
        set_contract_address(player1);

    }

}