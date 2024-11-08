use starknet::ContractAddress;
use dojo::world::storage::{WorldStorage, WorldStorageTrait};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

use planetelo::models::Member;
use planetelo::consts::ELO_DIFF;

use planetary_interface::interfaces::one_on_one_dispatcher::{
    IOneOnOneDispatcher, IOneOnOneDispatcherTrait,
};

fn get_planetelo_address(world_address: ContractAddress) -> ContractAddress {
    let mut world = IWorldDispatcher {contract_address: world_address};
    let mut world_storage = WorldStorageTrait::new(world, @"planetelo");
    let maybe_planetelo = world_storage.dns(@"planetelo");
    match maybe_planetelo {
        Option::Some((address, _)) => address,
        Option::None => panic!("Error Getting Planetelo Address"),
    }
}

fn get_planetelo_dispatcher(game: felt252) -> IOneOnOneDispatcher {

    let planetary: IPlanetaryActionsDispatcher = PlanetaryInterfaceTrait::new().dispatcher();
    assert!(planetary.get_world_address(game) != starknet::contract_address_const::<0x0>(), "Planetary Error");

    let world_address = planetary.get_world_address(game);
    assert!(world_address != starknet::contract_address_const::<0x0>(), "Error Getting World Address");

 
    let planetelo_address = get_planetelo_address(world_address);
    IOneOnOneDispatcher{ contract_address: planetelo_address }
}

fn find_match(members: @Array<Member>, player_index: Member) -> Option<Member> {
    let mut found = false;
    let mut potential_index: Member = Member { player: contract_address_const::<0x0>(), timestamp: 0, elo: 0 };
    loop {
        match members.pop_front() {
            Option::Some(member) => {
                if member.player == address {
                    //do nothing
                }
                else {
                    potential_index = member;

                    let mut elo_diff = 0;
                    if potential_index.elo > player_index.elo {
                        elo_diff = potential_index.elo - player_index.elo;
                    }
                    else {
                        elo_diff = player_index.elo - potential_index.elo;
                    }
                    if elo_diff < ELO_DIFF {
                        found = true;
                        break;
                    }
                }
            },
            Option::None => {
                break;
            }
        }
    };

}

fn get_queue_members(world: WorldStorage, game: felt252, playlist: u128) -> Array<Member> {
    let mut members: Array<Member> = Array::new();
    let queue: Queue = world.read_model((game, playlist));
    let member_ids = queue.members;
    loop {
        match member_ids.pop_front() {
            Option::Some(id) => {
                let member: Member = world.read_model(id);
                members.append(member);
            },
            Option::None => {
                break;
            }
        }
    }
    members
}