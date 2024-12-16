use octoguns::types::TurnMove;
use octoguns::models::characters::CharacterPosition;
use dojo::world::WorldStorage;
use dojo::model::{ModelStorage, ModelValueStorage, Model};
use octoguns::models::sessions::SessionMeta;

fn get_move_positions(ref world: WorldStorage, ref moves: TurnMove) -> Array<Array<CharacterPosition>> {
    //TODO: ASSERT ALL CHARACTERS ARE MOVED AND ONLY ONE MOVE PER CHARACTER >
    let mut positions: Array<Array<CharacterPosition>> = ArrayTrait::new();
    let mut i = 0;
    while i < moves.actions.len() {
        let mut temp = ArrayTrait::new();
        let action = moves.actions[i];
        let mut j = 0;
        while j < action.characters.len() {
            let position: CharacterPosition = world.read_model(*action.characters[j]);
            temp.append(position);
            j+=1;
        };
        positions.append(temp);
        i += 1;
    };
    positions
}

// returns (all_positions, opp_positions)
fn get_rest_positions(ref world: WorldStorage, meta: @SessionMeta, player: u8) -> Array<CharacterPosition> {
    let mut opp = ArrayTrait::new();

    let mut i = 0;
    let mut len = 0;
    if player == 1 {
        len = meta.p1_characters.len();
    } else {
        len = meta.p2_characters.len();
    }

    loop {

        if i < meta.p2_characters.len() && player == 1 {
            let mut position: CharacterPosition = world.read_model(*meta.p2_characters[i]);
            opp.append(position);
            i+=1;
        }
        else if i < meta.p1_characters.len() && player == 2 {
            let mut position: CharacterPosition = world.read_model(*meta.p1_characters[i]);
            opp.append(position);
            i+=1;
        }
        else {
            break;
        }
    };

    opp
}

#[cfg(test)]
mod tests {
    use super::{get_move_positions, get_rest_positions};
    use octoguns::tests::helpers::{get_test_settings, get_test_turn_move};
    use octoguns::tests::world_setup::{setup, setup_game};

    use dojo::world::WorldStorage;
    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use octoguns::models::sessions::SessionMeta;


    #[test]
    fn test_get_move_positions() {
        let (mut world, start, _actions, spawn, _) = setup();
        let p1 = starknet::contract_address_const::<0x1>();
        let p2 = starknet::contract_address_const::<0x2>();
        let _session_id = setup_game(start, spawn, p1, p2);

        let mut turn_move = get_test_turn_move(array![]);
        let move_positions = get_move_positions(ref world, ref turn_move);
        assert!(move_positions.len() == 2);
        assert!(move_positions[0].len() == 2);
        assert!(move_positions[1].len() == 1);
    }

    #[test]
    fn test_get_rest_positions() {
        let (mut world, start, _actions, spawn, _) = setup();
        let p1 = starknet::contract_address_const::<0x1>();
        let p2 = starknet::contract_address_const::<0x2>();
        let session_id = setup_game(start, spawn, p1, p2);

        let mut meta: SessionMeta = world.read_model(session_id);
        let rest_positions = get_rest_positions(ref world, @meta, 2);
        assert!(rest_positions.len() == 3);
    }
}