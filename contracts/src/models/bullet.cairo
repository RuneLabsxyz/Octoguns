use octoguns::types::{Vec2};
use octoguns::models::character::{CharacterPosition, CharacterPositionTrait}; 
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
    pub direction: u32, // in degrees
    pub shot_by: ContractAddress
}

#[derive(Copy, Drop, Serde)]
pub struct Vec2_i64 {
    x: i64,
    y: i64,
}


#[generate_trait]
impl BulletImpl of BulletTrait {

    fn new(id: u32, coords: Vec2, speed: u32, direction: u32, player: ContractAddress) -> Bullet {
        Bullet { bullet_id: id, coords, speed, direction, shot_by: player}
    }


    fn simulate(ref self: Bullet, characters: @Array<CharacterPosition>) -> (Option<Bullet>, u32) {
        let position = self.coords;
        let position_x = position.x;
        let position_y = position.y;
        let speed = self.speed;
        let direction = self.direction;

        let character_id = self.compute_hits(characters);

        if character_id != 0 {
            return (Option::None(()), character_id);
        }

        let x_shift = (fast_sin(direction.into()) * speed.into()) / TEN_E_8;
        let y_shift = (fast_cos(direction.into()) * speed.into()) / TEN_E_8;

        let new = Vec2_i64 { x: position_x.into() + x_shift, y: position_y.into() + y_shift};

        if new.x < 100 || new.x > 10_100 || new.y < 100 || new.y > 10_100 {
            return (Option::None(()), character_id);
        }
        let new_vec2 = Vec2 { x: new.x.try_into().unwrap() , y: new.y.try_into().unwrap() };
        self.coords = new_vec2;

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

            if self.coords.x + 100 >= lower_bound_x && self.coords.x + 100 <= upper_bound_x &&
            self.coords.y + 100 >= lower_bound_y && self.coords.y + 100 <= upper_bound_y {
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

    use octoguns::types::{CharacterPosition, CharacterPositionTrait};
    use super::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::tests::helpers::{get_test_character_array};

    #[test]
   fn test_bullet_sim_y_only()  {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 0, address);
        let characters = get_test_character_array();
        let (res, id) = bullet.simulate(@characters);
        match res {
            Option::None => {
                panic!("Should not be none");
            },
            Option::Some(bullet) => {
                assert!(bullet.coords.y == 1, "y should have changed");
                assert!(bullet.coords.x == 3, "x should not have changed")
            }
        }
    }

    #[test]
    fn test_bullet_sim_x_only()  {
        let address = starknet::contract_address_const::<0x0>();

         let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 90, address);
         let characters = get_test_character_array();
         let (res, id) = bullet.simulate(@characters);
         match res {
             Option::None => {
                 panic!("Should not be none");
             },
             Option::Some(bullet) => {
                println!("x: {}, y: {}", bullet.coords.x, bullet.coords.y);
                 assert!(bullet.coords.x == 4, "x should have changed");
                 assert!(bullet.coords.y == 0, "y should not have changed");
             }
         }
     }


     #[test]
     fn test_collision() {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 0, address);
        let characters = array![CharacterPositionTrait::new(69,4,0,100,0)];
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

        let mut bullet = BulletTrait::new(1, Vec2 { x:700, y:1}, 1, 0, address);
        let characters = array![CharacterPositionTrait::new(69,4,0,100,0)];
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