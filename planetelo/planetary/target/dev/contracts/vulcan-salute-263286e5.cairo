#[starknet::contract]
pub mod salute {
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
        fn name(self: @ContractState) -> ByteArray {
            "salute"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "vulcan"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "vulcan-salute"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            1044125266394117888426237411966329773191864072720986786228683473669038365155
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            1358933841220433637416262960427034891603970168610704807478270243365978482068
        }

        fn selector(self: @ContractState) -> felt252 {
            1079822601025751022028002008519316022162744659927767460966934944365774913207
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

    use super::IVulcan;
    use debug::PrintTrait;
    use core::traits::Into;
    use starknet::{ContractAddress, get_contract_address, get_caller_address, get_tx_info};

    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait, IPlanetaryActionsDispatcher,
        IPlanetaryActionsDispatcherTrait,
    };
    use planetary_interface::interfaces::vulcan::{VulcanInterface, VulcanInterfaceTrait,};
    use planetary_interface::utils::misc::{WORLD};
    #[starknet::interface]
    pub trait IDojoInit<ContractState> {
        fn dojo_init(ref self: ContractState);
    }

    #[abi(embed_v0)]
    pub impl IDojoInitImpl of IDojoInit<ContractState> {
        fn dojo_init(ref self: ContractState) {
            let world = self.world_dispatcher.read();
            if starknet::get_caller_address() != self.world().contract_address {
                core::panics::panic_with_byte_array(
                    @format!(
                        "Only the world can init contract `{}`, but caller is `{:?}`",
                        self.tag(),
                        starknet::get_caller_address()
                    )
                );
            }
            let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
            planetary
                .dispatcher()
                .register(VulcanInterfaceTrait::NAMESPACE, world.contract_address);
        }
    }
    #[abi(embed_v0)]
    impl IVulcanImpl of IVulcan<ContractState> {
        fn live_long(self: @ContractState) -> felt252 {
            let world = self.world_dispatcher.read();
            WORLD(world);
            ('and_prosper')
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

