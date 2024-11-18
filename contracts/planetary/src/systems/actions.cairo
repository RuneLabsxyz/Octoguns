use starknet::ContractAddress;
use dojo::world::IWorldDispatcher;

// Interfaces

#[starknet::interface]
trait IPlanetaryActions<T> {
    fn register(ref self: T, name: felt252, world_address: ContractAddress);
    fn unregister(ref self: T, name: felt252);
    fn get_world_address(self: @T, name: felt252) -> ContractAddress;
}

// Contracts

#[dojo::contract]
mod planetary_actions {
    use super::IPlanetaryActions;
    use starknet::ContractAddress;
    use planetary::models::planet::{
        Planet, PlanetTrait
    };

    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use dojo::event::EventStorage;

    mod Errors {
        const PLANET_UNAVAILABLE: felt252 = 'PLANETARY: Unavailable';
    }

    #[abi(embed_v0)]
    impl ActionsImpl of super::IPlanetaryActions<ContractState> {
        fn register(ref self: ContractState, name: felt252, world_address: ContractAddress) {

            let mut world = self.world(@"planetary");
            let mut planet: Planet = world.read_model(name);

            assert!(planet.is_available == false, "planet already exists");
            let planet = Planet {
                name,
                world_address,
                is_available: true,
            };
            world.write_model(@planet);
        }

        fn unregister(ref self: ContractState, name: felt252) {

            let mut world = self.world(@"planetary");
            let mut planet: Planet = world.read_model(name);
            assert(planet.is_available == true, Errors::PLANET_UNAVAILABLE);
            planet.is_available = false;
            world.write_model(@planet);
        }

        fn get_world_address(self: @ContractState, name: felt252) -> ContractAddress {
            let world = self.world(@"planetary");
            let planet: Planet = world.read_model(name);
            (planet.world_address)
        }
    }
}
