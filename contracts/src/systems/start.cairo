use starknet::{ContractAddress, get_caller_address};

#[dojo::interface]
trait IStart {
    fn create(ref world: IWorldDispatcher, map_id: u32) -> u32;
    fn create_closed(ref world: IWorldDispatcher, map_id: u32, player_address_1: ContractAddress, player_address_2: ContractAddress);
    fn join(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod start {
    use super::IStart;
    use octoguns::models::sessions::{Session, SessionTrait, SessionMeta, SessionMetaTrait};
    use starknet::{ContractAddress, get_caller_address};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::GLOBAL_KEY;
    use octoguns::models::player::{Player};

    #[abi(embed_v0)]
    impl StartImpl of IStart<ContractState> {
        fn create(ref world: IWorldDispatcher, map_id: u32) -> u32 {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            // Do shit
            let address = get_caller_address();
            let mut player = get!(world, address, (Player));
            let id = world.uuid();
            global.create_session(id);
            player.games.append(id);

            let session = SessionTrait::new(id, address, map_id);
            let session_meta = SessionMetaTrait::new(id);
            set!(world, (session, session_meta, global, player));
            id
        }

        fn create_closed(ref world: IWorldDispatcher, map_id: u32, player_address_1: ContractAddress, player_address_2: ContractAddress) {
            let mut player_1 = get!(world, player_address_1, (Player));
            let mut player_2 = get!(world, player_address_2, (Player));
            let id = world.uuid();
            player_1.games.append(id);
            player_2.games.append(id);

            let session = SessionTrait::new_closed(id, player_address_1, player_address_2, map_id);
            let session_meta = SessionMetaTrait::new(id);
            set!(world, (session, session_meta, 
                Player {player: player_address_1, games: player_1.games}, 
                Player {player: player_address_2, games: player_2.games}
            ));
        }

        fn join(ref world: IWorldDispatcher, session_id: u32) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            let address = get_caller_address();
            let mut session = get!(world, session_id, (Session));
            let mut player = get!(world, address, (Player));

            assert!(session.state == 0, "already started session");
           
            assert!(session.player1 != address, "can't join own session");
            global.remove_session(session_id);
            session.join(address);
            player.games.append(session.session_id);

            set!(world, (session, player, global));        
        }
    }
}