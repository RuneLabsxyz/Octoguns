#[cfg(test)]
mod test_world_setup{
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::{WorldStorageTrait, IWorldDispatcher, WorldStorage};
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef};

    use starknet::{contract_address_const, ContractAddress};
    use starknet::testing::{set_contract_address};
    // import test utils
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait, m_CharacterPosition, m_CharacterModel};
    use octoguns::models::map::{Map, MapTrait, m_Map};
    use octoguns::models::sessions::{Session, SessionMeta, SessionPrimitives, m_SessionPrimitives, m_Session, m_SessionMeta};
    use octoguns::models::bullet::{Bullet, BulletTrait, m_Bullet};
    use octoguns::models::global::{Global, m_Global};
    use octoguns::models::player::{Player, m_Player};

    use octoguns::types::{TurnMove, Vec2, IVec2, Shot};

    use octoguns::consts::{ONE_E_8, GLOBAL_KEY};
    use octoguns::systems::start::{start, IStartDispatcher, IStartDispatcherTrait}; 
    use octoguns::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use octoguns::systems::spawn::{spawn, ISpawnDispatcher, ISpawnDispatcherTrait};
    use octoguns::systems::mapmaker::{mapmaker, IMapmakerDispatcher, IMapmakerDispatcherTrait};

    use octoguns::tests::helpers::{get_test_settings, get_test_turn_move};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "octoguns", resources: [
                TestResource::Model(m_CharacterPosition::TEST_CLASS_HASH),
                TestResource::Model(m_CharacterModel::TEST_CLASS_HASH),
                TestResource::Model(m_Map::TEST_CLASS_HASH),
                TestResource::Model(m_Session::TEST_CLASS_HASH),
                TestResource::Model(m_SessionMeta::TEST_CLASS_HASH),
                TestResource::Model(m_Bullet::TEST_CLASS_HASH),
                TestResource::Model(m_Global::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                TestResource::Model(m_SessionPrimitives::TEST_CLASS_HASH),
                TestResource::Contract(start::TEST_CLASS_HASH),
                TestResource::Contract(actions::TEST_CLASS_HASH),
                TestResource::Contract(spawn::TEST_CLASS_HASH),
                TestResource::Contract(mapmaker::TEST_CLASS_HASH)
            ].span()
        };

        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"octoguns", @"start")
                .with_writer_of([dojo::utils::bytearray_hash(@"octoguns")].span()),
            ContractDefTrait::new(@"octoguns", @"actions")
                .with_writer_of([dojo::utils::bytearray_hash(@"octoguns")].span()),
            ContractDefTrait::new(@"octoguns", @"spawn")
                .with_writer_of([dojo::utils::bytearray_hash(@"octoguns")].span()),
            ContractDefTrait::new(@"octoguns", @"mapmaker")
                .with_writer_of([dojo::utils::bytearray_hash(@"octoguns")].span())
        ].span()
    }

    fn setup() -> ( WorldStorage, 
                    IStartDispatcher, 
                    IActionsDispatcher,
                    ISpawnDispatcher,
                    IMapmakerDispatcher) {
        
        let ndef = namespace_def();
        let world: WorldStorage = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (start_address, _) = world.dns(@"start").unwrap();
        let (actions_address, _) = world.dns(@"actions").unwrap();
        let (spawn_address, _) = world.dns(@"spawn").unwrap();
        let (mapmaker_address, _) = world.dns(@"mapmaker").unwrap();

        let start_system = IStartDispatcher {contract_address: start_address}; 
        let actions_system = IActionsDispatcher {contract_address: actions_address};
        let spawn_system = ISpawnDispatcher {contract_address: spawn_address};
        let mapmaker_system = IMapmakerDispatcher {contract_address: mapmaker_address};

        mapmaker_system.default_map();

        (world, start_system, actions_system, spawn_system, mapmaker_system)
    }

    fn setup_game(start_system: IStartDispatcher, spawn_system: ISpawnDispatcher, p1: ContractAddress, p2: ContractAddress) -> u32 {
        set_contract_address(p1);
        let settings = get_test_settings();
        let session_id = start_system.create(0, settings);
        set_contract_address(p2);
        start_system.join(session_id);
        spawn_system.spawn(session_id);
        session_id
    }
}