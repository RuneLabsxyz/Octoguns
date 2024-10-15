use octoguns::lib::bitwise::{pow2_const};

fn set_grid_bit(character_x: u64, character_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> (u256, u256, u256) {
    let (x, y) = convert_coords_to_grid_indices(character_x, character_y);
    let index: u16 = (y * 25 + x); // valid range is 0-624

    if index < 128_u16 {
        let new_grid_1 = grid_1 + pow2_const(index); 
        return (new_grid_1, grid_2, grid_3);
    } else if index < 256_u16 {
        let new_grid_2 = grid_2 + pow2_const(index - 128_u16); 
        return (grid_1, new_grid_2, grid_3);
    } else {
        let new_grid_3 = grid_3 + pow2_const(index - 256_u16);
        return (grid_1, grid_2, new_grid_3);
    }
}


// Helper function to convert coordinates to grid indices
fn convert_coords_to_grid_indices(x: u64, y: u64) -> (u16, u16) {
    let grid_x: u16 = (x / 4000).try_into().unwrap(); // 100000 / 25 = 4000
    let grid_y: u16 = (y / 4000).try_into().unwrap(); // 100000 / 25 = 4000
    (grid_x, grid_y)
}

fn check_collision(bullet_x: u64, bullet_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> bool {
    let (x, y) = convert_coords_to_grid_indices(bullet_x, bullet_y);
    let index: u16 = y * 25 + x;
    if index < 128_u16 {
        let mask = pow2_const(index);
        return (grid_1 / mask) % 2 != 0;
    } else if index < 256_u16 {
        let mask = pow2_const(index - 128_u16);
        return (grid_2 / mask) % 2 != 0;
    } else {
        let mask = pow2_const(index - 256_u16);
        return (grid_3 / mask) % 2 != 0;
    }
}

fn convert_bullet_to_grid(bullet_x: u64, bullet_y: u64) -> (u256, u256, u256) {
    let (x, y) = convert_coords_to_grid_indices(bullet_x, bullet_y);
    let index: u16 = y * 25 + x; // valid range is 0-624

    if index < 128_u16 {
        let grid_1 = pow2_const(index);
        return (grid_1, 0, 0);
    } else if index < 256_u16 {
        let grid_2 = pow2_const(index - 128_u16);
        return (0, grid_2, 0);
    } else {
        let grid_3 = pow2_const(index - 256_u16);
        return (0, 0, grid_3);
    }
}




#[cfg(test)]
mod grid_tests {
    use octoguns::lib::grid::{set_grid_bit, check_collision};

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
}