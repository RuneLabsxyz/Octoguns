#[cfg(test)]
mod tests {
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use dojo::model::{Model, ModelTest, ModelIndex, ModelEntityTest};
    // import test utils
    use dojo::utils::test::{spawn_test_world, deploy_contract};
    use starknet::testing::{set_caller_address};
    use starknet::ContractAddress;
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

    #[test]
    fn test_setup() {
        let (world, _, _, _) = setup();
    }


}