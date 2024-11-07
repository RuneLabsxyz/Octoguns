
#[starknet::interface]
trait ITournamentActionsDispatcher<T> {
    fn create_tournament(ref self: T, game: felt252, playlist: u128, config: TournamentConfig) -> u128;
    fn join_tournament(ref self: T, tournament_id: u128) -> u128;
    fn settle_tournament(ref self: T, tournament_id: u128) -> u128;
    fn start_tournament(ref self: T, tournament_id: u128) -> u128;
}


#[derive(Copy, Drop, Serde)]
pub struct TournamentConfig {
    swiss_rounds: u8,
    top_cut: u8, //as a power of 2 (top 8 = 3, top 16 = 4, etc.)
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Tournament {
    #[key]
    id: u128,
    game: felt252,
    playlist: u128,
    config: TournamentConfig,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Pool {
    #[key]
    tournament_id: u128,
    #[key]
    wins: u8,
    players: ArrayTrait<Player>,
}


#[dojo::contract]
mod tournament {

    use super::{ITournamentActionsDispatcher, Tournament, Pool};
    

    #[abi(embed_v0)]
    impl TournamentImpl of ITournamentActionsDispatcher<ContractState> {
        fn create_tournament(ref self: ContractState, game: felt252, playlist: u128, config: TournamentConfig) -> u128 {
            
            
            
            tournament_id
        }   


    }
}   


