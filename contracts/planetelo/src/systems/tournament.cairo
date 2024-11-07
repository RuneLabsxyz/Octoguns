use starknet::ContractAddress;
#[starknet::interface]
trait ITournamentActionsDispatcher<T> {
    fn create_tournament(ref self: T, game: felt252, playlist: u128, config: TournamentConfig) -> u128;
    fn join_tournament(ref self: T, tournament_id: u128) -> u128;
    fn settle_tournament(ref self: T, tournament_id: u128) -> u128;
    fn start_tournament(ref self: T, tournament_id: u128) -> u128;
    fn advance_tournament(ref self: T, tournament_id: u128);
}


#[derive(Copy, Drop, Serde, Introspect)]
pub struct TournamentConfig {
    swiss_rounds: u8,
    top_cut: u8, //as a power of 2 (top 8 = 3, top 16 = 4, etc.)
    entry_time: u64
}



#[derive(Drop, Serde)]
#[dojo::model]
pub struct Tournament {
    #[key]
    id: u128,
    game: felt252,
    playlist: u128,
    round: u8,
    start_time: u64,
    config: TournamentConfig,
    pairings: Array<Pairing>,
}

#[derive(Copy, Drop, Serde, Introspect)]
pub struct Pairing {
    player_1: ContractAddress,
    player_2: ContractAddress,
    game_id: u128,
    status: u8, //0 = waiting, 1 = in_game, 2 = finished
}


#[derive(Drop, Serde)]
#[dojo::model]
pub struct Pool {
    #[key]
    tournament_id: u128,
    #[key]
    wins: u8,
    players: Array<ContractAddress>,
}


#[dojo::contract]
mod tournament {

    use super::{ITournamentActionsDispatcher, Tournament, Pool};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};
    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
    };
    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};


    use planetary_interface::interfaces::one_on_one::{
        IOneOnOneDispatcher, IOneOnOneDispatcherTrait, Status
    };

    use planetary_interface::utils::systems::{get_world_contract_address};
    

    #[abi(embed_v0)]
    impl TournamentImpl of ITournamentActionsDispatcher<ContractState> {
        fn create_tournament(ref self: ContractState, game: felt252, playlist: u128, config: TournamentConfig) -> u128 {
            let mut world = self.world(@"planetelo");

            let tournament_id = world;
            let tournament = Tournament { 
                id: tournament_id, 
                game, 
                playlist,
                round:1, 
                config, 
                start_time: get_block_timestamp() 
            };
            world.write_model(tournament);
            
            tournament_id
        }   

        fn join_tournament(ref self: ContractState, tournament_id: u128) {
            let mut world = self.world(@"planetelo");

            let tournament: Tournament = world.read_model(tournament_id);

            assert!(tournament.round == 1, "Tournament not joinable");
            let mut pool: Pool = world.read_model((tournament_id, 0));

            let player = get_caller_address();
            pool.players.push(player);

            world.write_model(pool);
            
        }

        fn advance_tournament(ref self: ContractState, tournament_id: u128) {
            let mut world = self.world(@"planetelo");

            let tournament: Tournament = world.read_model(tournament_id);
        }


    }
}   


