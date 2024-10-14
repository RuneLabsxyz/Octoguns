#[starknet::contract]
pub mod planetary_actions {
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
            "planetary_actions"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "planetary"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "planetary-planetary_actions"
        }

        fn name_hash(self: @ContractState) -> felt252 {
            518901053641817465802474752847185310205647380857721703091769283857967995854
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            2276933370664470240081104061729369934160808170901121539663944855600660169724
        }

        fn selector(self: @ContractState) -> felt252 {
            1739181936182946217275277884200392512296530105841733302407683212849490757599
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

    use super::IPlanetaryActions;
    use starknet::ContractAddress;
    use planetary::models::planet::{Planet, PlanetTrait, PlanetStore, PlanetModelImpl,};

    mod Errors {
        const PLANET_UNAVAILABLE: felt252 = 'PLANETARY: Unavailable';
    }

    #[abi(embed_v0)]
    impl ActionsImpl of super::IPlanetaryActions<ContractState> {
        fn register(ref self: ContractState, name: felt252, world_address: ContractAddress) {
            let world = self.world_dispatcher.read();
            let planet = Planet { name, world_address, is_available: true, };
            planet.set(world);
        }
        fn unregister(ref self: ContractState, name: felt252) {
            let world = self.world_dispatcher.read();
            let mut planet: Planet = PlanetStore::get(world, name);
            assert(planet.is_available == true, Errors::PLANET_UNAVAILABLE);
            planet.is_available = false;
            planet.set(world);
        }
        fn get_world_address(self: @ContractState, name: felt252) -> ContractAddress {
            let world = self.world_dispatcher.read();
            let planet: Planet = PlanetStore::get(world, name);
            (planet.world_address)
        }
    }
    #[generate_trait]
    impl ActionsInternalImpl of ActionsInternalTrait {
        fn assert_caller_is_contract(ref world: IWorldDispatcher) {}
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

