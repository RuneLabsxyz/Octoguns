#[dojo::interface]
trait IStart {
    fn create(ref world: IWorldDispatcher);
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
        fn create(ref world: IWorldDispatcher) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            // Do shit
            let address = get_caller_address();
            let mut player = get!(world, address, (Player));
            let id = world.uuid();
            global.create_session(id);
            player.games.append(id);

            let session = SessionTrait::new(id, address, 1);
            let session_meta = SessionMetaTrait::new(id);
            set!(world, (session, session_meta, global, player));
        }

        fn join(ref world: IWorldDispatcher, session_id: u32) {
            let global = get!(world, GLOBAL_KEY, (Global));

            let mut session = get!(world, session_id, (Session));

            let player = get_caller_address();
            assert!(session.player1 != player, "can't join own session");
            //TODO global.remove_session(session_id);
            session.join(player);

            set!(world, (session));        
        }
    }
}