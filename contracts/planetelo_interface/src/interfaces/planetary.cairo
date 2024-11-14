use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource, WorldStorage, WorldStorageTrait};

#[starknet::interface]
trait IPlanetaryActions<TState> {
    fn register(ref self: TState, name: felt252, world_address: ContractAddress);
    fn unregister(ref self: TState, name: felt252);
    fn get_world_address(ref self: TState, name: felt252) -> ContractAddress;
}

struct Planetary {
    world: WorldStorage
}

#[generate_trait]
impl PlanetaryImpl of PlanetaryTrait {
    fn WORLD_CONTRACT() -> ContractAddress {
        (starknet::contract_address_const::<0x12e4037b9904e439251127d689aed16e4494c3e82a12982ed3183d7bf29350b>())
    }
    fn new() -> WorldStorage {
        (WorldStorageTrait::new(IWorldDispatcher {contract_address: Self::WORLD_CONTRACT()}, @"planetary"))
    }

    fn dispatcher(self: Planetary) -> IPlanetaryActionsDispatcher {
        let (contract_address, _) = self.world.dns(@"planetary_actions").unwrap();
        (IPlanetaryActionsDispatcher{contract_address})
    }
}