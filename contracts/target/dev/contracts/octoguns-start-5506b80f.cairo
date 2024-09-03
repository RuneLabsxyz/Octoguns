#[starknet::contract]
pub mod start {
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
            "start"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "octoguns"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "octoguns-start"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            90978911299710641914325376348783840359004045280752488366562762512657188725
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            1924336117031027642112813060054040969607345629178792935276372212332421167173
        }

        fn selector(self: @ContractState) -> felt252 {
            2403653972481980853605461466954164342349152371000185935237565206818273599540
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

    use super::IStart;
    use octoguns::models::sessions::{Session, SessionTrait, SessionMeta, SessionMetaTrait};
    use starknet::{ContractAddress, get_caller_address};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::GLOBAL_KEY;
    use octoguns::models::player::{Player};

    #[abi(embed_v0)]
    impl StartImpl of IStart<ContractState> {
        fn create(ref self: ContractState) {
            let world = self.world_dispatcher.read();
            let mut global = get!(world, GLOBAL_KEY, (Global));
            // Do shit
            let address = get_caller_address();
            let mut player = get!(world, address, (Player));
            let id = world.uuid();
            global.create_session(id);
            player.games.append(id);

            let session = SessionTrait::new(id, address, 1);
            let session_meta = SessionMetaTrait::new(id);
            set!(world, (session, session_meta, global, player));
        }
        fn join(ref self: ContractState, session_id: u32) {
            let world = self.world_dispatcher.read();
            let mut global = get!(world, GLOBAL_KEY, (Global));
            let address = get_caller_address();
            let mut session = get!(world, session_id, (Session));
            let mut player = get!(world, address, (Player));

            assert!(session.state == 0, "already started session");

            assert!(session.player1 != address, "can't join own session");
            //TODO global.remove_session(session_id);
            global.remove_session(session_id);
            session.join(address);
            player.games.append(session.session_id);

            set!(world, (session, player, global));
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

