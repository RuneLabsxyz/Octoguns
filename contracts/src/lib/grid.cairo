use octoguns::lib::bitwise::{pow2_const};

fn set_grid_bit(character_x: u64, character_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> (u256, u256, u256) {
    let (x, y) = convert_coords_to_grid_indices(character_x, character_y);
    let index: u16 = (y * 25 + x).into(); // valid range is 0-624

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
fn convert_coords_to_grid_indices(x: u64, y: u64) -> (u8, u8) {
    let grid_x = (x / 4000).try_into().unwrap(); // 100000 / 25 = 4000
    let grid_y = (y / 4000).try_into().unwrap(); // 100000 / 25 = 4000
    (grid_x, grid_y)
}

fn check_collision(bullet_x: u64, bullet_y: u64, grid_1: u256, grid_2: u256, grid_3: u256) -> bool {
    let (x, y) = convert_coords_to_grid_indices(bullet_x, bullet_y);
    let index: u16 = (y * 25 + x).into();
    if index < 128 {
        let mask = pow2_const(index);
        return (grid_1 & mask) != 0;
    } else if index < 256 {
        let mask = pow2_const(index - 128_u16);
        return (grid_2 & mask) != 0;
    } else {
        let mask = pow2_const(index - 256_u16);
        return (grid_3 & mask) != 0;
    }
}




#[cfg(test)]
mod grid_tests {
    use octoguns::lib::grid::{set_grid_bit, check_collision};

    #[test]
    fn test_set_grid_bit() {
        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(grid1, grid2, grid3, 14, 0);
        println!("new_grid1: {}", new_grid1);
        println!("new_grid2: {}", new_grid2);
        println!("new_grid3: {}", new_grid3);
    }
}
