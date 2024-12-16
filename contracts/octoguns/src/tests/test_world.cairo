#[cfg(test)]
mod tests {
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::{WorldStorageTrait, IWorldDispatcher, WorldStorage};
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef};
    
    use starknet::{contract_address_const, ContractAddress};
    use starknet::testing::{set_contract_address};
    // import test utils
    use octoguns::models::characters::{CharacterModel, CharacterPosition, CharacterPositionTrait, m_CharacterPosition, m_CharacterModel};
    use octoguns::models::map::{Map, MapTrait, m_Map};
    use octoguns::models::sessions::{Session, SessionMeta, SessionPrimitives, m_SessionPrimitives, m_Session, m_SessionMeta};
    use octoguns::models::bullet::{Bullet, BulletTrait, m_Bullet};
    use octoguns::models::global::{Global, m_Global};
    use octoguns::models::player::{Player, m_Player};

    use octoguns::types::{TurnMove, Vec2, IVec2, Shot};

    use octoguns::consts::{ONE_E_8, GLOBAL_KEY};
    use octoguns::systems::start::{start, IStartDispatcher, IStartDispatcherTrait}; 
    use octoguns::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use octoguns::systems::spawn::{spawn, ISpawnDispatcher, ISpawnDispatcherTrait};
    use octoguns::systems::mapmaker::{mapmaker, IMapmakerDispatcher, IMapmakerDispatcherTrait};

    use octoguns::tests::helpers::{get_test_settings, get_test_turn_move};
    use octoguns::tests::world_setup::test_world_setup::{setup, setup_game};

    #[test]
    fn test_setup() {
        let (_, _, _, _, _) = setup();
    }

    #[test]
    fn test_game_setup() {
        let (world, start, _, spawn, _) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let session: Session = world.read_model(session_id);
        assert_eq!(session.player1, player1, "p1 is not set");
        assert_eq!(session.player2, player2, "p2 is not set");

    }

    #[test]
    fn test_move() {
        let (world, start, actions, spawn, _) = setup();
        let player1: ContractAddress = contract_address_const::<0x01>();
        let player2: ContractAddress = contract_address_const::<0x02>();
        let session_id = setup_game(start, spawn, player1, player2);
        let _session: Session = world.read_model(session_id);
        let session_meta: SessionMeta = world.read_model(session_id);


        set_contract_address(player1);
        let turn_move = get_test_turn_move(session_meta.p1_characters);

        let session_meta: SessionMeta = world.read_model(session_id);
        let mut p_characters = session_meta.p1_characters;
        let char: CharacterPosition = world.read_model(*p_characters.at(0));
        actions.move(session_id, turn_move);
        let new_char: CharacterPosition = world.read_model(*p_characters.at(0));
        assert!(char.coords.x != new_char.coords.x || char.coords.y != new_char.coords.y, "Character should have moved");

        set_contract_address(player2);
        let turn_move = get_test_turn_move(session_meta.p2_characters);
        actions.move(session_id, turn_move);

    }

    // #[test]
    // fn test_hit_self() {
    //     let (world, start, actions, spawn, _) = setup();
    //     let player1: ContractAddress = contract_address_const::<0x01>();
    //     let player2: ContractAddress = contract_address_const::<0x02>();

    //     let session_id = setup_game(start, spawn, player1, player2);

    //     let session = get!(world, session_id, (Session));
    //     let session_meta = get!(world, session_id, (SessionMeta));
    
    //     set_contract_address(player1);
    //     let mut shots = ArrayTrait::new();
    //     let mut sub_moves = ArrayTrait::new();
    //     let mut i: u32 = 0;
    //     while i < 100 {
    //         sub_moves.append(IVec2 {x: 100, y: 0, xdir: true, ydir: true});
    //         i+=1;
    //     };
    //     shots.append(Shot {angle: 0, step: 0});
    //     actions.move(session_id, TurnMove {sub_moves, shots});
    //     let session = get!(world, session_id, (Session));
    //     assert!(session.state == 2, "Game should not have ended");
    
    // }

    // #[test]
    // fn test_collision_in_move() {
    //     let (world, start, actions, spawn, _) = setup();
    //     let player1: ContractAddress = contract_address_const::<0x01>();
    //     let player2: ContractAddress = contract_address_const::<0x02>();

    //     let session_id = setup_game(start, spawn, player1, player2);

    //     let session = get!(world, session_id, (Session));
    //     let session_meta = get!(world, session_id, (SessionMeta));

    //     set_contract_address(player1);
    //     let mut shots = ArrayTrait::new();
    //     let mut sub_moves = ArrayTrait::new();
    //     let mut i: u32 = 0;
    //     while i < 100 {
    //         sub_moves.append(IVec2 {x: 0, y: 0, xdir: true, ydir: true});
    //         i+=1;
    //     };

    //     shots.append(Shot {angle: 90 * TEN_E_8, step: 0});
    //     actions.move(session_id, TurnMove {sub_moves, shots});
    //     // bullet travels 25000 units per turn, so it should take 3 turns to hit 
    //     let session_meta = get!(world, session_id, (SessionMeta));
    //     let mut bullet_id = 0;
    //     if session_meta.bullets.len() > 0 {
    //         bullet_id = *session_meta.bullets.at(0);
    //     }
    //     else {
    //     }
    //     let bullet = get!(world, bullet_id, (Bullet));

    //     set_contract_address(player2);
    //     actions.move(session_id, TurnMove {sub_moves: ArrayTrait::new(), shots: ArrayTrait::new()});
    //     let bullet = get!(world, bullet_id, (Bullet));

    //     set_contract_address(player1);
    //     actions.move(session_id, TurnMove {sub_moves: ArrayTrait::new(), shots: ArrayTrait::new()});
    //     let bullet = get!(world, bullet_id, (Bullet));

    //     let session = get!(world, session_id, (Session));
    //     assert!(session.state == 3, "Game should have ended");

    // }
}