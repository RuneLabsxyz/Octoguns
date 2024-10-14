use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use octoguns::lib::trig::{fast_cos_unsigned, fast_sin_unsigned};
use octoguns::consts::ONE_E_8;
use starknet::ContractAddress;
use octoguns::consts::{MOVE_SPEED, BULLET_SPEED, BULLET_SUBSTEPS};
use octoguns::models::map::{Map, MapTrait};
use octoguns::types::{IVec2, Vec2};
use octoguns::lib::grid::{check_collision, set_grid_bit, convert_bullet_to_grid};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Bullet {
    #[key]
    pub bullet_id: u32,
    pub shot_step: u16,
    pub shot_by: u32,
    pub shot_at: Vec2,
    pub velocity: IVec2, // store the step velocity
}

#[generate_trait]
impl BulletImpl of BulletTrait {
    fn new(
        id: u32,
        coords: Vec2,
        angle: u64,
        shot_by: u32,
        shot_step: u16,
        bullet_speed: u64,
        bullet_sub_steps: u32
    ) -> Bullet {
        //speed is how much it travels per sub step
        //distance travelled per turn is speed * STEP_COUNT
        let (cos, xdir) = fast_cos_unsigned(angle);
        let (sin, ydir) = fast_sin_unsigned(angle);
        let speed_per_sub_step = bullet_speed / bullet_sub_steps.into();
        let velocity = IVec2 {
            x: (cos * speed_per_sub_step) / ONE_E_8,
            y: (sin * speed_per_sub_step) / ONE_E_8,
            xdir,
            ydir
        };
        Bullet {
            bullet_id: id,
            shot_at: coords,
            shot_by,
            shot_step: shot_step * bullet_sub_steps.try_into().unwrap(),
            velocity
        }
    }

    fn get_position(ref self: Bullet, step: u32) -> Option<Vec2> {
        let mut new_coords = self.shot_at;
        let step_felt: felt252 = (step - self.shot_step.into()).into();
        let vx: felt252 = self.velocity.x.into();
        let vy: felt252 = self.velocity.y.into();

        let mut x_shift: u64 = (vx * step_felt).try_into().unwrap();
        let mut y_shift: u64 = (vy * step_felt).try_into().unwrap();

        if self.velocity.xdir {
            new_coords.x += x_shift;
            if new_coords.x > 100_000 {
                return Option::None(());
            }
        } else {
            if x_shift > self.shot_at.x {
                return Option::None(());
            }
            new_coords.x -= x_shift;
        }
        if self.velocity.ydir {
            new_coords.y += y_shift;
            if new_coords.y > 100_000 {
                return Option::None(());
            }
        } else {
            if y_shift > self.shot_at.y {
                return Option::None(());
            }
            new_coords.y -= y_shift;
        }
        Option::Some(new_coords)
    }

    fn simulate(
        ref self: Bullet,
        characters: @Array<CharacterPosition>,
        ref map: Map,
        step: u32,
        bullet_sub_steps: u32,
        ref grid1: u256,
        ref grid2: u256,
        ref grid3: u256
    ) -> (Option<u32>, bool) {
        let mut res: (Option<u32>, bool) = (Option::None(()), false);

        let mut bullet_step = step * bullet_sub_steps;

        while bullet_step < step * bullet_sub_steps + bullet_sub_steps {
            let maybe_position = self.get_position(bullet_step);
            let mut position: Vec2 = Vec2 { x: 0, y: 0 };

            match maybe_position {
                Option::None => {
                    res = (Option::None(()), true);
                    break;
                },
                Option::Some(p) => { position = p; }
            }

            // Always compute hit with objects
            let (hit_object, object_hit) = self.compute_hit_objects(position, ref map);
            if object_hit {
                // If hit an object, bullet should be removed
                res = (Option::None(()), true);
                break;
            }

            // checks for collisions
            if !check_collision(position.x, position.y, grid1, grid2, grid3) {
                //No collisions, with the pre-check
                res = (Option::None(()), false);
                break;
            }

            res = self.compute_hit_characters(position, characters, grid1, grid2, grid3);

            bullet_step += 1;
        };

        let (hit_character, hit_object) = res;

        match hit_character {
            Option::Some(character_id) => { return (Option::Some(character_id), true); },
            Option::None => { return (Option::None(()), hit_object); }
        }
    }

    /// Computes collision with objects (e.g., walls)
    fn compute_hit_objects(
        ref self: Bullet,
        position: Vec2,
        ref map: Map, 
    ) -> (bool, bool) {

        let map_grid_1 = map.grid1;
        let map_grid_2 = map.grid2;
        let map_grid_3 = map.grid3;

        let (grid1, grid2, grid3) = convert_bullet_to_grid(position.x, position.y);

        if (map_grid_1 & grid1) == 0 && (map_grid_2 & grid2) == 0 && (map_grid_3 & grid3) == 0 {
            return (false, false);
        } else {
            return (true, true);
        }
    }

    /// Computes collision with characters
    fn compute_hit_characters(
        ref self: Bullet, 
        position: Vec2, 
        characters: @Array<CharacterPosition>, 
        grid1: u256, 
        grid2: u256, 
        grid3: u256
    ) -> (Option<u32>, bool) {
        let mut character_index: u32 = 0;
        let mut character_id = 0;
        let OFFSET: u64 = 1000;
        let offset_x = position.x + OFFSET;
        let offset_y = position.y + OFFSET;
        let half_range: u64 = 500;
        let mut character_hit = false;

        while character_index < characters.len() {
            let character = *characters.at(character_index);
            let char_x = character.coords.x + OFFSET;
            let char_y = character.coords.y + OFFSET;

            // Plus 1000 offset to match bounds offset
            if (offset_x > char_x - half_range && offset_x < char_x + half_range &&
                offset_y > char_y - half_range && offset_y < char_y + half_range) {
                if character.id != self.shot_by {
                    character_id = character.id;
                    character_hit = true;
                    break;
                }
            }

            character_index += 1;
        };

        if character_hit {
            (Option::Some(character_id), true)
        } else {
            (Option::None(()), false)
        }
    }
}


#[cfg(test)]
mod simulate_tests {
    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use super::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::tests::helpers::{get_test_character_array};
    use octoguns::consts::{BULLET_SPEED, BULLET_SUBSTEPS, ONE_E_8, STEP_COUNT};
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::lib::grid::{set_grid_bit, check_collision};
    use octoguns::lib::grid::{pow2_const};
    #[test]
    fn test_new_bullet() {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 0, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
    }


    #[test]
    fn test_bullet_position_y_only() {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new_empty(1);

        let mut bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 90 * ONE_E_8, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let position = bullet.get_position(1).unwrap();
        assert!(position.x == 0, "x should not have changed");
        assert!(
            position.y == BULLET_SPEED / BULLET_SUBSTEPS.into(), "y should have changed by speed"
        );
    }

    #[test]
    fn test_bullet_position_x_only() {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new_empty(1);

        let mut bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 0, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let position = bullet.get_position(1).unwrap();

        assert!(
            position.x == BULLET_SPEED / BULLET_SUBSTEPS.into(), "x should have changed by speed"
        );
        assert!(position.y == 0, "y should not have changed");
    }


    #[test]
    fn test_collision_with_character() {
        let address = starknet::contract_address_const::<0x0>();

        let map_grid1 = 0;
        let map_grid2 = 0;
        let map_grid3 = 0;
        let mut map = MapTrait::new(0, map_grid1, map_grid2, map_grid3);

        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let character_coords = Vec2 { x: 14, y: 0 };

        let (new_grid1, new_grid2, new_grid3) = set_grid_bit(14, 0, grid1, grid2, grid3);
        grid1 = new_grid1;
        grid2 = new_grid2;
        grid3 = new_grid3;

        let mut bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 0, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let characters = array![CharacterPositionTrait::new(69, character_coords, STEP_COUNT)];
        let (hit_character, dropped) = bullet.simulate(@characters, ref map, 1, BULLET_SUBSTEPS, ref grid1, ref grid2, ref grid3);
        match hit_character {
            Option::None => { panic!("should return id of hit piece"); },
            Option::Some(id) => { assert!(id == 69, "not returning id of hit piece"); }
        }
        assert!(dropped, "should return true for hit object");
    }

    #[test]
    fn test_drop_bullet() {
        let address = starknet::contract_address_const::<0x0>();

        let map_grid1 = pow2_const(12 * 25);
        let map_grid2 = pow2_const(12 * 25 + 1);
        let map_grid3 = pow2_const(12 * 25 + 2);
        let mut map = MapTrait::new(0, map_grid1, map_grid2, map_grid3);
        let characters = ArrayTrait::new();

        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let mut bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 180 * ONE_E_8, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let (hit_character, dropped) = bullet.simulate(@characters, ref map, 1, BULLET_SUBSTEPS, ref grid1, ref grid2, ref grid3);
        match hit_character {
            Option::Some(character_id) => { panic!("bullet should not hit character"); },
            Option::None => { if !dropped {
                panic!("should return true");
            } }
        }
    }

    #[test]
    fn test_collision_with_object() {
        let address = starknet::contract_address_const::<0x0>();

        let map_grid1 = pow2_const(7) | pow2_const(8) | pow2_const(9);
        let map_grid2 = 0;
        let map_grid3 = 0;
        let mut map = MapTrait::new(0, map_grid1, map_grid2, map_grid3);

        let characters = ArrayTrait::new();

        let mut grid1 = 0;
        let mut grid2 = 0;
        let mut grid3 = 0;

        let mut bullet = BulletTrait::new(1, Vec2 { x: 30_000, y: 0 }, 0, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let (hit_character, dropped) = bullet.simulate(@characters, ref map, 1, BULLET_SUBSTEPS, ref grid1, ref grid2, ref grid3);
        match hit_character {
            Option::None => { if !dropped {
                panic!("should return true for hit object");
            } },
            Option::Some(character_id) => { panic!("bullet should hit wall not character"); }
        }
    }

    #[test]
    fn test_collision_with_object_2() {
        let address = starknet::contract_address_const::<0x0>();

        let map_grid1 = pow2_const(12 * 25);
        let map_grid2 = pow2_const(12 * 25 + 1);
        let map_grid3 = pow2_const(12 * 25 + 2);
        let mut map = MapTrait::new(0, map_grid1, map_grid2, map_grid3);

        let characters = ArrayTrait::new();

        let mut grid1 = 0;  
        let mut grid2 = 0;
        let mut grid3 = 0;

        let mut bullet = BulletTrait::new(1, Vec2 { x: 27_850, y: 0 }, 0, 1, 0, BULLET_SPEED, BULLET_SUBSTEPS);
        let (hit_character, dropped) = bullet.simulate(@characters, ref map, 3, BULLET_SUBSTEPS, ref grid1, ref grid2, ref grid3);
        match hit_character {
            Option::None => { if !dropped {
                panic!("should return true for hit object");
            } },
            Option::Some(character_id) => { panic!("bullet should hit wall not character"); }
        }
    }
}