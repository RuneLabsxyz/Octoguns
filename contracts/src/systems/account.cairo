#[dojo::interface]
trait IAccount {
    fn create_account(ref world: IWorldDispatcher, player_name: ByteArray);
}

#[dojo::contract]
mod account {
    use super::IAccount;
    use octoguns::models::player::{Player, PlayerTrait};

    #[abi(embed_v0)]
    impl AccountImpl of IAccount<ContractState> {
        fn create_account(ref world: IWorldDispatcher, player_name: ByteArray) {
            let address = get_caller_address();
            let player = PlayerTrait::new(address, player_name);
            set!(world, (player));
        }   
    }

}
