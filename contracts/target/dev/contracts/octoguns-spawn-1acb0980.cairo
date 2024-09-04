#[starknet::contract]
pub mod spawn {
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
            "spawn"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "octoguns"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "octoguns-spawn"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            2776321589048333240377325502911505147617911439383944762363370901236132332849
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            1924336117031027642112813060054040969607345629178792935276372212332421167173
        }

        fn selector(self: @ContractState) -> felt252 {
            757429349625253720859610252084731787890814254175152751215961837425087111899
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

    use super::ISpawn;
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::characters::{
        CharacterModel, CharacterModelTrait, CharacterPosition, CharacterPositionTrait,
    };
    use octoguns::types::Vec2;
    use octoguns::lib::default_spawns::{generate_character_positions};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SpawnImpl of ISpawn<ContractState> {
        fn spawn(ref self: ContractState, session_id: u32) {
            let world = self.world_dispatcher.read();
            let position_1 = Vec2 { x: 5000, y: 2000 };
            let position_2 = Vec2 { x: 5000, y: 8000 };

            let mut session = get!(world, session_id, (Session));
            assert!(session.state == 1, "Not spawnable");
            let caller = get_caller_address();
            let mut session_meta = get!(world, session_id, (SessionMeta));
            let player2 = session.player2;

            let id1 = world.uuid();

            let default_steps = 10;
            let c1 = CharacterModelTrait::new(id1, session_id, session.player1, default_steps);
            let p1 = CharacterPositionTrait::new(id1, position_1, 100, 0);
            session_meta.p1_character = id1;

            let id2 = world.uuid();
            let c2 = CharacterModelTrait::new(id2, session_id, session.player2, default_steps);
            let p2 = CharacterPositionTrait::new(id2, position_2, 100, 0);
            session_meta.p2_character = id2;

            session.state = 2;
            set!(world, (session, session_meta, c1, p1, c2, p2));
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

