#[starknet::interface]
trait ISpawn<T> {
    fn spawn(self: @T, session_id: u32);
}

#[dojo::contract]
mod spawn {
    use super::ISpawn;
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait, SessionPrimitives};
    use octoguns::models::characters::{
        CharacterModel, CharacterModelTrait, CharacterPosition, CharacterPositionTrait,
    };
    use octoguns::types::Vec2;
    use octoguns::lib::default_spawns::{generate_character_positions};
    use starknet::{ContractAddress, get_caller_address};
    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use octoguns::models::global::{Global, GlobalTrait, GlobalImpl};
    use octoguns::consts::{GLOBAL_KEY};


    #[abi(embed_v0)]
    impl SpawnImpl of ISpawn<ContractState> {
        fn spawn(self: @ContractState, session_id: u32) {
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            let position_1 = Vec2 { x: 50000, y: 20000 };
            let position_2 = Vec2 { x: 50000, y: 80000 };

            let mut session: Session = world.read_model(session_id);
            assert!(session.state == 1, "Not spawnable");
            let caller = get_caller_address();
            let mut session_meta: SessionMeta = world.read_model(session_id);
            assert!(caller == session.player1 || caller == session.player2, "Not player");

            let mut session_primitives: SessionPrimitives = world.read_model(session_id);

            let id1 = global.uuid();

            let default_steps = 10;
            let c1 = CharacterModelTrait::new(id1, session_id, session.player1, default_steps);
            let p1 = CharacterPositionTrait::new(
                id1, position_1, session_primitives.sub_moves_per_turn
            );
            session_meta.p1_character = id1;

            let id2 = global.uuid();
            let c2 = CharacterModelTrait::new(id2, session_id, session.player2, default_steps);
            let p2 = CharacterPositionTrait::new(
                id2, position_2, session_primitives.sub_moves_per_turn
            );
            session_meta.p2_character = id2;

            session.state = 2;
            world.write_model(@session);
            world.write_model(@session_meta);
            world.write_model(@c1);
            world.write_model(@p1);
            world.write_model(@c2);
            world.write_model(@p2);
            world.write_model(@global);
        }
    }
}
