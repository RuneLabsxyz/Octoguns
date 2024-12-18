use octoguns::lib::default_spawns::generate_character_positions;
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use octoguns::models::sessions::{Settings, Session, SessionMeta, SessionTrait, SessionMetaTrait};
use octoguns::types::{Vec2, TurnMove, Shot, IVec2, Action};


fn get_test_player_character_array(ids: Array<Array<u32>>) -> (Array<Array<CharacterPosition>>, Array<u32>) {
    let mut i = 0;
    let mut res: Array<Array<CharacterPosition>> = ArrayTrait::new();
    let mut flat_ids: Array<u32> = ArrayTrait::new();
    while i < ids.len() {
        let mut chars: Array<CharacterPosition> = ArrayTrait::new();
        let mut j = 0;
        while j < ids[i].len() {
            chars.append(CharacterPositionTrait::new(*ids.at(i).at(j), Vec2 { x: 20000, y: 20000 }, 100));
            flat_ids.append(*ids.at(i).at(j));
            j += 1;
        };
        res.append(chars);
        i += 1;
    };
    (res, flat_ids)
}

fn get_test_opp_character_array(ids: Array<u32>) -> Array<CharacterPosition> {
    let mut index = 0;
    let mut res: Array<CharacterPosition> = ArrayTrait::new();
    while index < ids.len() {
        res.append(CharacterPositionTrait::new(*ids[index], Vec2 { x: 80000, y: 20000 }, 100));
        index += 1;
    };
    res
}

fn get_test_settings() -> Settings {
    Settings {
        bullet_speed: 300,
        bullet_steps: 3,
        bullets: 1,
        sub_moves: 100,
        sub_move_distance: 400,
        characters: 3,
        actions: 2
    }
}

fn get_test_turn_move(ids: Array<u32>) -> TurnMove {
    //todo actually use ids
    let mut sub_moves: Array<IVec2> = ArrayTrait::new();
    let mut i: u32 = 0;
    while i < 100 {
        sub_moves.append(IVec2 { x: 0, y: 400, xdir: false, ydir: false });
        i += 1;
    };
    let mut shots: Array<Shot> = ArrayTrait::new();
    let shot: Shot = Shot {
        step: 50,
        angle: 900_000_000
    };
    shots.append(shot);
    let actions: Array<Action> = array![
        Action {
            characters: array![1,3],
            sub_moves: sub_moves.clone(),
            shots: shots.clone()
        },
        Action {
            characters: array![5],
            sub_moves: sub_moves.clone(),
            shots: shots.clone()
        }
    ];
    TurnMove {
        actions
    }
}