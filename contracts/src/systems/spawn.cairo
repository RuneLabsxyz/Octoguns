#[dojo::interface]
trait ISpawn {
    fn spawn(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod spawn {
    use super::ISpawn;
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::characters::{CharacterModel,CharacterModelTrait,
                                      CharacterPosition,CharacterPositionTrait, 
                                      };
    use octoguns::types::Vec2;
    use octoguns::lib::default_spawns::{generate_character_positions};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SpawnImpl of ISpawn<ContractState> {
        fn spawn(ref world: IWorldDispatcher, session_id: u32) {
        let positions_1 = generate_character_positions(1);
            let positions_2 = generate_character_positions(2);
            let mut session = get!(world, session_id, (Session));
            assert!(session.state == 1, "Not spawnable");
            let caller = get_caller_address();
            let mut session_meta = get!(world, session_id, (SessionMeta));
            let player2 = session.player2;
            let mut p1_ids = ArrayTrait::new();
            let mut p2_ids = ArrayTrait::new();

            let mut i = 0;
            loop {
                if i >= positions_1.len() {
                    break;
                }
                let position_1 = *positions_1[i];
                let position_2 = *positions_2[i];
                let id1 = world.uuid();

                let default_steps = 10;
                let c1 = CharacterModelTrait::new(id1, session_id, session.player1, default_steps);
                let p1 = CharacterPositionTrait::new(id1, position_1);
                p1_ids.append(id1);
                        
       

                let id2 = world.uuid();
                let c2 = CharacterModelTrait::new(id2, session_id, session.player2, default_steps);
                let p2 = CharacterPositionTrait::new(id2, position_2);
                p2_ids.append(id2);
                set!(world,(c1,p1,c2,p2));
                

                i += 1;
            } ;
            session.state = 2;
            session_meta.p1_characters = p1_ids;
            session_meta.p2_characters = p2_ids;
            set!(world, (session, session_meta));
        }
    }
}