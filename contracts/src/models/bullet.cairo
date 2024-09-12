use octoguns::types::{Vec2, IVec2};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait}; 
use alexandria_math::trigonometry::{fast_cos, fast_sin};
use octoguns::consts::TEN_E_8_I;
use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Bullet {
    #[key]
    pub bullet_id: u32,
    pub coords: Vec2,
    pub speed: u32, // pixels per step
    pub angle: u64, // in degrees
    pub shot_by: u32
}

#[derive(Copy, Drop, Serde)]
pub struct Vec2_i64 {
    x: i64,
    y: i64,
}


#[generate_trait]
impl BulletImpl of BulletTrait {

    fn new(id: u32, coords: Vec2, angle: u64, player: u32) -> Bullet {
        //speed is how much it travels per sub step
        //distance travelled per turn is speed * 100
        Bullet { bullet_id: id, coords, speed: 250, angle, shot_by: player}
    }


    fn simulate(ref self: Bullet, characters: @Array<CharacterPosition>) -> (Option<Bullet>, Option<u32>) {
        let speed = self.speed;
        let direction: i64 = self.angle.try_into().unwrap();
        let mut is_dropped: bool = false;
        let mut res: (Option<Bullet>, Option<u32>) = (Option::Some(self), Option::None(())); 


        let x_shift = (fast_cos(direction) * speed.into()) / TEN_E_8_I; 
        let y_shift = (fast_sin(direction) * speed.into()) / TEN_E_8_I;
        let new_x: i64 = self.coords.x.try_into().unwrap() + x_shift;
        let new_y: i64 = self.coords.y.try_into().unwrap() + y_shift;
        

        if new_x < 0 || new_x > 100_000 || new_y < 0 || new_y > 100_000 {
            // out of bounds    
            return (Option::None(()), Option::None(()));
        }

        self.coords = Vec2 { x: new_x.try_into().unwrap(), y: new_y.try_into().unwrap() };

        let hit_result = self.compute_hits(characters);
        match hit_result {
            Option::None => {
            },
            // hit a character
            Option::Some(character_id) => {
                res = (Option::Some(self), Option::Some(character_id));
            }
        }

        let ( bullet, hit_result) = res;

        if is_dropped {
            return (Option::None(()), Option::None(()));
        }
        match hit_result {
            Option::Some(character_id) => {
                return (Option::None(()), Option::Some(character_id));
            },
            Option::None => {
                return (Option::Some(self), Option::None(()));
            }
        }

        

    }

    fn compute_hits(ref self: Bullet, characters: @Array<CharacterPosition>) -> Option<u32> {
        let mut character_index: u32 = 0;
        let mut character_id = 0;

        loop {
            if character_index >= characters.len() {
                break;
            }


            let character = *characters.at(character_index);

            //PLUS 1000 OFFSET
            let lower_bound_x = character.coords.x + 1000 - 500;
            let upper_bound_x = character.coords.x + 1000 + 500;
            let lower_bound_y = character.coords.y + 1000 - 500;
            let upper_bound_y = character.coords.y + 1000 + 500;


            if (self.coords.x + 1000 > lower_bound_x && self.coords.x + 1000 < upper_bound_x &&
            self.coords.y + 1000 > lower_bound_y && self.coords.y + 1000 < upper_bound_y) {
                character_id = character.id;
                break;        
            }

            character_index += 1;
        };

        //ignore collision with the player that shot the bullet
        if character_id == 0 || character_id == self.shot_by {
            return Option::None(());
        }

        Option::Some(character_id)
    }


}


#[cfg(test)]
mod simulate_tests {

    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use super::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::tests::helpers::{get_test_character_array};
    use octoguns::consts::TEN_E_8;
    #[test]
   fn test_bullet_sim_y_only()  {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:300, y:0}, 90 * TEN_E_8, 1);
        let characters = ArrayTrait::new();
        let (new_bullet, id) = bullet.simulate(@characters);
        match new_bullet {
            Option::None => {
                panic!("Should not be none");
            },
            Option::Some(bullet) => {
                println!("bullet.coords.x: {}, bullet.coords.y: {}", bullet.coords.x, bullet.coords.y);
                assert!(bullet.coords.x == 300, "x should not have changed");
                assert!(bullet.coords.y == 250, "y should have changed by 100");
            }
        }
    }

    #[test]
    fn test_bullet_sim_x_only()  {
        let address = starknet::contract_address_const::<0x0>();

         let mut bullet = BulletTrait::new(1, Vec2 { x:0, y:0}, 0, 1);
         let characters = ArrayTrait::new();
         let (new_bullet, id) = bullet.simulate(@characters);
         match new_bullet {
             Option::None => {
                 panic!("Should not be none");
             },
             Option::Some(bullet) => {

                assert!(bullet.coords.x == 250, "x should have changed by 100");
                assert!(bullet.coords.y == 0, "y should not have changed");
             }
         }
     }


     #[test]
     fn test_collision() {
        let address = starknet::contract_address_const::<0x0>();

        let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 0, 1);
        let characters = array![CharacterPositionTrait::new(69, Vec2 {x: 14, y: 0})];
        let (new_bullet, res) = bullet.simulate(@characters);
        match new_bullet {
            Option::None => {
                match res {
                    Option::None => {
                        panic!("should return id of hit piece");
                    },
                    Option::Some(id) => {
                        assert!(id == 69, "not returning id of hit piece");
                    }
                }
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

        let mut bullet = BulletTrait::new(1, Vec2 { x:700, y:1}, 0, 1);
        let characters = array![CharacterPositionTrait::new(69,Vec2 {x: 4, y: 0})];
        let (new_bullet, res) = bullet.simulate( @characters);
        match new_bullet {
            Option::None => {
                match res {
                    Option::None => {
                        panic!("should return id of hit piece");
                    },
                    Option::Some(id) => {
                        assert!(id == 69, "not returning id of hit piece");
                    }
                }
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }
}