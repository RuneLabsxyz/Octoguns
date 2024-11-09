use starknet::ContractAddress;
use dojo::world::storage::{WorldStorage, WorldStorageTrait};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};
use dojo::model::{ModelStorage, ModelValueStorage, Model};


use starknet::contract_address_const;


use planetelo::models::{QueueStatus, Queue, Game};

use planetelo::models::Member;
use planetelo::consts::ELO_DIFF;

use planetary_interface::interfaces::one_on_one::{
    IOneOnOneDispatcher, IOneOnOneDispatcherTrait, Status
};

use planetelo::elo::{EloTrait};

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

fn find_match(ref members: Array<Member>, ref player: Member) -> Option<Member> {
    let mut found = false;
    let mut potential_index: Member = Member { id: 0, player: contract_address_const::<0x0>(), timestamp: 0, elo: 0 };
    let mut res = Option::None;
    
    loop {
        match members.pop_front() {
            Option::Some(potential_index) => {
                if potential_index.player == player.player {
                    //do nothing
                }
                else {

                    let mut elo_diff = 0;
                    if potential_index.elo > player.elo {
                        elo_diff = potential_index.elo - player.elo;
                    }
                    else {
                        elo_diff = player.elo - potential_index.elo;
                    }
                    if elo_diff != 0 {
                        panic!("Both elos should be the same");
                    }
                    if elo_diff < ELO_DIFF {
                        res = Option::Some(potential_index);
                        break;
                    }
                    else {
                        panic!("Elo difference is too high");
                    }
                }
            },
            Option::None => {
                panic!("??");
                break;
            }
        }
    };
    Option::None


}

fn get_queue_members(world: WorldStorage, game: felt252, playlist: u128) -> Array<Member> {
    let mut members: Array<Member> = ArrayTrait::new();
    let queue: Queue = world.read_model((game, playlist));
    let mut i = 0;
    while i < queue.members.len() {
        let member: Member = world.read_model( *queue.members[i]);
        members.append(member);
        i+=1;
    };
    members
}

fn update_elos(status: Status, game_model: @Game, ref one_elo: u64, ref two_elo: u64) -> (u64, u64) {
    match status {
        Status::None => {
            panic!("Match has doesn't exist");
        },
        Status::Active => {
            panic!("Match is still active");
        },
        Status::Draw => {

            let (mag, sign) = EloTrait::rating_change(one_elo, two_elo, 50_u16, 20_u8);

            if sign {
                one_elo += mag;
                two_elo -= mag;
            }
            else {
                one_elo -= mag;
                two_elo += mag;
            }
            

        },
        Status::Winner(winner) => {

            let mut did_win: u16 = 0;

            if winner == *game_model.player1 {
                did_win = 100;
            }

            let (mag, sign) = EloTrait::rating_change(one_elo, two_elo, did_win, 20_u8);

            if sign {
                one_elo += mag;
                two_elo -= mag;
            }
            else {
                one_elo -= mag;
                two_elo += mag;
            }

        }
    }

    (one_elo, two_elo)
}