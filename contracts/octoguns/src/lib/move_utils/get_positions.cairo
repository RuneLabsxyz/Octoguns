fn get_move_positions(ref world: WorldStorage, ref moves: TurnMove) -> Array<Array<CharacterPosition>> {
    let mut positions: Array<Array<CharacterPosition>> = ArrayTrait::new();
    let mut i = 0;
    while i < moves.actions.len() {
        let mut temp = ArrayTrait::new();
        let action = moves.actions[i];
        let mut j = 0;
        while j < action.characters.len() {
            let position: CharacterPosition = world.read_model(*action.characters[j]);
            temp.append(position);
        }
        let character_id = action.character_id;
        let position: CharacterPosition = world.read_model(character_id);
        positions.append(temp);
        i += 1;
    }
    positions
}

// returns (all_positions, opp_positions)
fn get_rest_positions(ref world: WorldStorage, ref meta: SessionMeta, player: u8) -> (Array<CharacterPosition>, Array<CharacterPosition>) {
    let mut all = ArrayTrait::new();
    let mut opp = ArrayTrait::new();

    let mut i = 0;
    let mut j = 0;

    loop {
        if i >= meta.p1_characters.len() && j >= meta.p2_characters.len() {
            break;
        }

        if i < meta.p1_characters.len() {
            let mut position: CharacterPosition = world.read_model(*meta.p1_characters[i]);
            all.append(position);

            if player == 2 {
                opp.append(position);
            }
            i+=1;
        }
        if j < meta.p2_characters.len() {
            let mut position: CharacterPosition = world.read_model(*meta.p2_characters[j]);
            all.append(position);

            if player == 1 {
                opp.append(position);
            }
            j+=1;
        }
    }
    (all, opp)
}