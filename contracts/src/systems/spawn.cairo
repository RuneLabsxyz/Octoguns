#[dojo::interface]
trait ISpawn {
    fn spawn(ref world: IWorldDispatcher, session_id: u32);
}

#[dojo::contract]
mod spawn {
    use super::ISpawn;
    use octoguns::models::sessions::{Session, SessionMeta, SessionMetaTrait};
    use octoguns::models::character::{Character,CharacterTrait,
                                      Position,PositionTrait, 
                                      Health, HealthTrait};
    use octoguns::lib::defaultSpawns::{generate_character_positions};
    use starknet::{ContractAddress, get_caller_address};

    #[abi(embed_v0)]
    impl SpawnImpl of ISpawn<ContractState> {
        fn spawn(ref world: IWorldDispatcher, session_id: u32) {
            let positions_1 = generate_character_positions(1);
            let positions_2 = generate_character_positions(2);
            let mut session = get!(world, session_id, (Session));
            let caller = get_caller_address();
            let mut session_meta = get!(world, session_id, (SessionMeta));


            let mut i = 0;
            loop {
                if i >= positions_1.len() {
                    break;
                }
                let position_1 = *positions_1[i];
                let position_2 = *positions_2[i];
                let id1 = world.uuid();

                let default_steps = 10;
                let c1 = CharacterTrait::new(id1, session_id, session.player1, default_steps);
                let p1 = PositionTrait::new(id1, position_1.x, position_1.y);
                let h1 = HealthTrait::new(id1, 100);
                session_meta.add_character(id1);
                        
       

                let id2 = world.uuid();
                let c2 = CharacterTrait::new(id2, session_id, session.player2, default_steps);
                let p2 = PositionTrait::new(id2, position_2.x, position_2.y);
                let h2 = HealthTrait::new(id2, 100);
                session_meta.add_character(id2);
                set!(world,(c1,p1,h1,c2,p2,h2));
                

                i += 1;
            } ;
            session.state = 2;
            set!(world, (session, session_meta));
        }
    }
}