use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
struct Player {
    #[key]
    player: ContractAddress,
    player_name: ByteArray,
    games: Array<u32>
}

#[generate_trait]
impl PlayerImpl of PlayerTrait {
    fn new(player: ContractAddress, player_name: ByteArray) -> Player {
        Player { player, player_name, games: ArrayTrait::new() } 
    }
}