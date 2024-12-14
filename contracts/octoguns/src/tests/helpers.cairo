use octoguns::lib::default_spawns::generate_character_positions;
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use octoguns::models::sessions::Settings;
use octoguns::types::{Vec2, TurnMove, Shot, IVec2, Action};


fn get_test_player_character_array(size: u8) -> Array<Array<CharacterPosition>> {
    let mut index: u8 = 0;
    let mut chars: Array<CharacterPosition> = ArrayTrait::new();
    while index < size {
        chars.append(CharacterPositionTrait::new(index.into(), Vec2 { x: 20000, y: 20000 }, 100));
        index += 1;
    };
    let mut res: Array<Array<CharacterPosition>> = ArrayTrait::new();
    res.append(chars);
    res.append(ArrayTrait::new());
    res.append(ArrayTrait::new());
    res
}

fn get_test_opp_character_array(size: u8) -> Array<CharacterPosition> {
    let mut index: u8 = 0;
    let mut res: Array<CharacterPosition> = ArrayTrait::new();
    while index < size.into() {
        res.append(CharacterPositionTrait::new(index.into(), Vec2 { x: 80000, y: 20000 }, 100));
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
        actions: 3
    }
}

fn get_test_turn_move() -> TurnMove {
    let mut sub_moves: Array<IVec2> = ArrayTrait::new();
    let mut i: u32 = 0;
    while i < 100 {
        sub_moves.append(IVec2 { x: 400, y: 0, xdir: false, ydir: false });
        i += 1;
    };
    let mut shots: Array<Shot> = ArrayTrait::new();
    let shot: Shot = Shot {
        step: 0,
        angle: 900_000_000
    };
    shots.append(shot);
    let actions: Array<Action> = array![
        Action {
            characters: array![0],
            sub_moves: sub_moves.clone(),
            shots: shots.clone()
        },
        Action {
            characters: array![1],
            sub_moves: sub_moves.clone(),
            shots: shots.clone()
        },
        Action {
            characters: array![2],
            sub_moves: sub_moves.clone(),
            shots: shots.clone()
        }
    ];
    assert!(actions.len() == 3, "actions len should be 3");
    TurnMove {
        actions
    }
}