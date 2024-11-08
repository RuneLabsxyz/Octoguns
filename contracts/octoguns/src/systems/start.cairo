use starknet::{ContractAddress, get_caller_address};
use octoguns::models::sessions::{
    Session, SessionTrait, SessionMeta, SessionMetaTrait, SessionPrimitives,
};
use octoguns::types::{Settings};

#[starknet::interface]
trait IStart<T> {
    fn create(self: @T, map_id: u32, settings: Settings) -> u32;
    fn create_closed(
        self: @T,
        map_id: u32,
        player_address_1: ContractAddress,
        player_address_2: ContractAddress,
        settings: Settings
    ) -> u128;
    fn join(self: @T, session_id: u32);
}

#[dojo::contract]
mod start {
    use super::IStart;
    use octoguns::models::sessions::{
        Session, SessionTrait, SessionMeta, SessionMetaTrait, SessionPrimitives,
        SessionPrimitivesTrait, SessionPrimitivesImpl, SessionMetaImpl
    };
    use starknet::{ContractAddress, get_caller_address};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::GLOBAL_KEY;
    use octoguns::models::player::{Player};
    use octoguns::types::{Settings};
    use dojo::model::{ModelStorage, ModelValueStorage, Model};


    #[abi(embed_v0)]
    impl StartImpl of IStart<ContractState> {
        fn create(self: @ContractState, map_id: u32, settings: Settings) -> u32 {
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            // Do shit
            let address = get_caller_address();
            let mut player: Player = world.read_model(address);
            let id = global.uuid();
            global.create_session(id);
            player.games.append(id);

            let session = SessionTrait::new(id, address, map_id);
            let session_meta = SessionMetaTrait::new(id);
            let session_primitives = SessionPrimitivesTrait::new(id, settings);

            world.write_model(@session);
            world.write_model(@session_meta);
            world.write_model(@global);
            world.write_model(@player);
            world.write_model(@session_primitives);
            world.write_model(@global);
            id
        }

        fn create_closed(
            self: @ContractState,
            map_id: u32,
            player_address_1: ContractAddress,
            player_address_2: ContractAddress,
            settings: Settings
        ) -> u128{
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            let mut player_1: Player = world.read_model(player_address_1);
            let mut player_2: Player = world.read_model(player_address_2);
            let id = global.uuid();
            player_1.games.append(id);
            player_2.games.append(id);
            assert!(player_1.player != player_2.player, "Players cannot be the same");

            let session = SessionTrait::new_closed(id, player_address_1, player_address_2, map_id);
            let session_meta = SessionMetaTrait::new(id);
            let session_primitives = SessionPrimitivesTrait::new(
                id,
                settings
            );
            world.write_model(@session);
            world.write_model(@session_meta);
            world.write_model(@player_1);
            world.write_model(@player_2);
            world.write_model(@session_primitives);
            world.write_model(@global);

            id.into()
        }

        fn join(self: @ContractState, session_id: u32) {
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            let address = get_caller_address();
            let mut session: Session = world.read_model(session_id);
            let mut player: Player = world.read_model(address);

            assert!(session.state == 0, "already started session");

            assert!(session.player1 != address, "can't join own session");
            global.remove_session(session_id);
            session.join(address);
            player.games.append(session.session_id);

            world.write_model(@session);
            world.write_model(@player);
            world.write_model(@global);
        }
    }
}