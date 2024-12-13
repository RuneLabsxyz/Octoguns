use octoguns::lib::bitwise::{pow2_const};
use octoguns::models::characters::CharacterPosition;

fn set_grid_bit(character_x: u64, character_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> (u256, u256, u256) {
    let (x, y) = convert_coords_to_grid_indices(character_x, character_y);
    let index: u16 = (25 * (y - 1) + x); // valid range is 0-624

    if index < 208_u16 {
        // Indices 0 to 207 go to grid_1
        let new_grid_1 = grid_1 + pow2_const(index); 
        return (new_grid_1, grid_2, grid_3);
    } else if index < 416_u16 {
        // Indices 208 to 415 go to grid_2
        let new_grid_2 = grid_2 + pow2_const(index - 208_u16); 
        return (grid_1, new_grid_2, grid_3);
    } else {
        // Indices 416 to 624 go to grid_3
        let new_grid_3 = grid_3 + pow2_const(index - 416_u16);
        return (grid_1, grid_2, new_grid_3);
    }
}


fn set_grid_bits_from_positions(move_positions: @Array<Array<CharacterPosition>>, opp_positions: @Array<CharacterPosition>) -> (u256, u256, u256) {
    let mut grid1: u256 = 0;
    let mut grid2: u256 = 0;
    let mut grid3: u256 = 0;
    let mut i = 0;


    loop {
        if i >= opp_positions.len() {
            break;
        }
        let position = *opp_positions.at(i);
        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(position.coords.x, position.coords.y, grid1, grid2, grid3);
        grid1 = new_grid1;
        grid2 = new_grid2;
        grid3 = new_grid3;
        i += 1;
    };

    let mut i = 0;
    let mut j = 0;
    loop {
        if i >= move_positions.len() {
            break;
        }
        let positions = move_positions.at(i);
        let mut j = 0;
        loop {
            if j >= positions.len() {
                break;
            }
            let position = *positions.at(j);
            let (new_grid1, new_grid2, new_grid3) = set_grid_bit(position.coords.x, position.coords.y, grid1, grid2, grid3);
            grid1 = new_grid1;
            grid2 = new_grid2;
            grid3 = new_grid3;
            j += 1;
        };
        i += 1;
    };

    (grid1, grid2, grid3)
}

// Helper function to convert coordinates to grid indices
fn convert_coords_to_grid_indices(x: u64, y: u64) -> (u16, u16) {

    let mut grid_x: u16 = (x / 4000).try_into().unwrap();
    let mut grid_y: u16 = (y / 4000).try_into().unwrap();

    if grid_x == 0 {
        grid_x = 1;
    }
    if grid_y == 0 {
        grid_y = 1;
    }

    (grid_x, grid_y)
}


fn check_collision(bullet_x: u64, bullet_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> bool {
    let (x, y) = convert_coords_to_grid_indices(bullet_x, bullet_y);
    let index: u16 = (25 * (y - 1) + x); // valid range is 0-624
    if index < 208_u16 {
        let mask = pow2_const(index);
        return (grid_1 / mask) % 2 != 0;
    } else if index < 416_u16 {
        let mask = pow2_const(index - 208_u16);
        return (grid_2 / mask) % 2 != 0;
    } else {
        let mask = pow2_const(index - 416_u16);
        return (grid_3 / mask) % 2 != 0;
    }
}


fn convert_bullet_to_grid(bullet_x: u64, bullet_y: u64) -> (u256, u256, u256) {
    let (x, y) = convert_coords_to_grid_indices(bullet_x, bullet_y);
    let index: u16 = (25 * (y - 1) + x); // valid range is 0-624

    if index < 208_u16 {
        let grid_1 = pow2_const(index);
        return (grid_1, 0, 0);
    } else if index < 416_u16 {
        let grid_2 = pow2_const(index - 208_u16);
        return (0, grid_2, 0);
    } else {
        let grid_3 = pow2_const(index - 416_u16);
        return (0, 0, grid_3);
    }
}


#[cfg(test)]
mod grid_tests {
    use octoguns::lib::grid::{set_grid_bit, check_collision, set_grid_bits_from_positions};
    use octoguns::types::Vec2;
    use octoguns::models::characters::CharacterPositionTrait;
    #[test]
    fn test_check_collision() {
        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(14, 0, grid1, grid2, grid3);
        
        let is_colliding = check_collision(14, 0, new_grid1, new_grid2, new_grid3);
        assert!(is_colliding, "should be colliding");
    }

    #[test]
    fn test_check_collision_no_collision() {
        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(14 * 4000, 1 * 4000, grid1, grid2, grid3);
        let is_colliding_1 = check_collision(15 * 4000, 1 * 4000, new_grid1, new_grid2, new_grid3);
        let is_colliding_2 = check_collision(14 * 4000, 2 * 4000, new_grid1, new_grid2, new_grid3);
        let is_colliding_3 = check_collision(13 * 4000, 0 * 4000, new_grid1, new_grid2, new_grid3);
        assert!(!is_colliding_1, "should not be colliding 1");
        assert!(!is_colliding_2, "should not be colliding 2");
        assert!(!is_colliding_3, "should not be colliding 3");
    }

    #[test]
    fn test_check_collision_edge() {
        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(14 * 4000, 1 * 4000, grid1, grid2, grid3);
        let is_colliding_1 = check_collision(15 * 3950, 1 * 4000, new_grid1, new_grid2, new_grid3);
        let is_colliding_2 = check_collision(14 * 4000, 2 * 3950, new_grid1, new_grid2, new_grid3);
        assert!(is_colliding_1, "should be colliding 1");
        assert!(is_colliding_2, "should be colliding 2");
    }

    #[test]
    fn test_initial_grid_bits() {
        let mut positions = ArrayTrait::new();
        let position_1 = Vec2 { x: 50000, y: 20000 };
        let position_2 = Vec2 { x: 50000, y: 80000 };
        let character_position_1 = CharacterPositionTrait::new(1, position_1, 10);
        let character_position_2 = CharacterPositionTrait::new(2, position_2, 10);
        positions.append(character_position_1);
        positions.append(character_position_2);
        let (grid1, grid2, grid3) = set_grid_bits_from_positions( @ArrayTrait::new(), @positions);
        println!("grid1: {}", grid1);
        println!("grid2: {}", grid2);
        println!("grid3: {}", grid3);
    }
}