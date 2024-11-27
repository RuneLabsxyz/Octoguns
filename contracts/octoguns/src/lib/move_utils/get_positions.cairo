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

    loop {
        if i >= meta.p1_characters.len() || i >= meta.p2_characters.len() {
            break;
        }

        if i < meta.p1_characters.len() {
            let mut position: CharacterPosition = world.read_model(*meta.p1_characters[i]);

            if player == 1 {
                opp.append(position);
            }

            i+=1;
        }
        if i < meta.p2_characters.len() {
            let mut position: CharacterPosition = world.read_model(*meta.p2_characters[i]);
            if player == 2 {
                opp.append(position);
            }

            i+=1;
        }
    };

    opp
}