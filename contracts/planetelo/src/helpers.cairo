use starknet::ContractAddress;
use dojo::world::storage::{WorldStorage, WorldStorageTrait};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};


fn get_planetelo_address(world_address: ContractAddress) -> ContractAddress {
    let mut world = IWorldDispatcher {contract_address: world_address};
    let mut world_storage = WorldStorageTrait::new(world, @"planetelo");
    let maybe_planetelo = world_storage.dns(@"planetelo");
    match maybe_planetelo {
        Option::Some((address, _)) => address,
        Option::None => panic!("Error Getting Planetelo Address"),
    }
}
