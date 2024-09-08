use octoguns::types::{Vec2, IVec2};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait}; 
use alexandria_math::trigonometry::{fast_cos, fast_sin};
use octoguns::consts::TEN_E_8;
use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Bullet {
    #[key]
    pub bullet_id: u32,
    pub coords: Vec2,
    pub speed: u32, // pixels per step
    pub angle: u32, // in degrees
    pub shot_by: ContractAddress
}

#[derive(Copy, Drop, Serde)]
pub struct Vec2_i64 {
    x: i64,
    y: i64,
}


#[generate_trait]
impl BulletImpl of BulletTrait {

    fn new(id: u32, coords: Vec2, angle: u32, player: ContractAddress) -> Bullet {
        Bullet { bullet_id: id, coords, speed: 75, angle, shot_by: player}
    }


    fn simulate(ref self: Bullet, characters: @Array<CharacterPosition>) -> (Option<Bullet>, u32) {
        let position = self.coords;
        let speed = self.speed;
        let direction: i64 = self.angle.into() * TEN_E_8;

        let character_id = self.compute_hits(characters);

        if character_id != 0 {
            return (Option::None(()), character_id);
        }

        let x_shift = (fast_sin(direction) * speed.into()) / TEN_E_8;
        let y_shift = (fast_cos(direction) * speed.into()) / TEN_E_8;

        let new_x: i64 = position.x.try_into().unwrap() + x_shift;
        let new_y: i64 = position.y.try_into().unwrap() + y_shift;

        println!("new position: {} {}", new_x, new_y);
        if new_x < 0 || new_x > 10_000 || new_y < 0 || new_y > 10_000 {
            return (Option::None(()), character_id);
        }

        self.coords = Vec2 { x: new_x.try_into().unwrap(), y: new_y.try_into().unwrap() };

        (Option::Some(self), character_id)
    }

    fn compute_hits(ref self: Bullet, characters: @Array<CharacterPosition>) -> u32 {
        let mut character_index: u32 = 0;
        let mut character_id = 0;

        loop {
            if character_index >= characters.len() {
                break;
            }

            let character = *characters.at(character_index);

            //PLUS 100 OFFSET
            let lower_bound_x = character.coords.x + 100 - 5;
            let upper_bound_x = character.coords.x + 100 + 5;
            let lower_bound_y = character.coords.y + 100 - 5;
            let upper_bound_y = character.coords.y + 100 + 5;

            if (self.coords.x + 100 >= lower_bound_x && self.coords.x + 100 <= upper_bound_x &&
            self.coords.y + 100 >= lower_bound_y && self.coords.y + 100 <= upper_bound_y) {
                character_id = character.id;
                break;        
            }

            character_index += 1;
        };

        character_id
    }


}


#[cfg(test)]
mod simulate_tests {

    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use super::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::tests::helpers::{get_test_character_array};

    #[test]
   fn test_bullet_sim_y_only()  {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:323, y:0}, 0, address);
        let characters = get_test_character_array();
        let (res, id) = bullet.simulate(@characters);
        match res {
            Option::None => {
                panic!("Should not be none");
            },
            Option::Some(bullet) => {
                assert!(bullet.coords.y == 75, "y should have changed by 75");
                assert!(bullet.coords.x == 323, "x should not have changed")
            }
        }
    }

    #[test]
    fn test_bullet_sim_x_only()  {
        let address = starknet::contract_address_const::<0x0>();

         let mut bullet = BulletTrait::new(1, Vec2 { x:753, y:0}, 90, address);
         let characters = get_test_character_array();
         let (res, id) = bullet.simulate(@characters);
         match res {
             Option::None => {
                 panic!("Should not be none");
             },
             Option::Some(bullet) => {
                println!("x: {}, y: {}", bullet.coords.x, bullet.coords.y);
                 assert!(bullet.coords.x == 828, "x should have changed by 75");
                 assert!(bullet.coords.y == 0, "y should not have changed");
             }
         }
     }


     #[test]
     fn test_collision() {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 0, address);
        let characters = array![CharacterPositionTrait::new(69, Vec2 {x: 4, y: 0},100,0)];
        let (res, id) = bullet.simulate(@characters);
        match res {
            Option::None => {
                assert!(id == 69, "not returning id of hit piece");
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }
     #[test]
     #[should_panic]
     fn test_collision_fail() {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:700, y:1}, 0, address);
        let characters = array![CharacterPositionTrait::new(69,Vec2 {x: 4,y: 0},100,0)];
        let (res, id) = bullet.simulate( @characters);
        match res {
            Option::None => {
                assert!(id == 69, "not returning id of hit piece");
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }
}