use octoguns::types::{Vec2, IVec2};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait}; 
use alexandria_math::trigonometry::{fast_cos, fast_sin};
use octoguns::consts::TEN_E_8_I;
use starknet::ContractAddress;
use octoguns::consts::{MOVE_SPEED, BULLET_SPEED};
use octoguns::models::map::{Map, MapTrait};

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
        Bullet { bullet_id: id, coords, speed: BULLET_SPEED, angle, shot_by: player}
    }


    fn simulate(ref self: Bullet, characters: @Array<CharacterPosition>, map: @Map) -> (Option<Bullet>, Option<u32>) {
        let speed = self.speed;
        let direction: i64 = self.angle.try_into().unwrap();
        let mut is_dropped: bool = false;
        let mut res: (Option<Bullet>, Option<u32>) = (Option::Some(self), Option::None(())); 

        let mut i: u32 = 0;
        while i < 4 {
            let x_shift = (fast_cos(direction) * speed.into()) / (TEN_E_8_I * 4); 
            let y_shift = (fast_sin(direction) * speed.into()) / (TEN_E_8_I * 4);
            let new_x: i64 = self.coords.x.try_into().unwrap() + x_shift;
            let new_y: i64 = self.coords.y.try_into().unwrap() + y_shift;
            

            if new_x < 0 || new_x > 100_000 || new_y < 0 || new_y > 100_000 {
                // out of bounds    
                res = (Option::None(()), Option::None(()));
                is_dropped = true;
                break;
            }

            self.coords = Vec2 { x: new_x.try_into().unwrap(), y: new_y.try_into().unwrap() };

            let (hit_character, hit_object) = self.compute_hits(characters, map);
            match hit_character {
                Option::None => {
                    is_dropped = hit_object;
                    if hit_object {
                        break;
                    }
                },
                // hit a character
                Option::Some(character_id) => {
                    res = (Option::Some(self), Option::Some(character_id));
                    break;
                }
            }
            i += 1;
        };

        let ( _ , hit_result) = res;

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

    fn compute_hits(ref self: Bullet, characters: @Array<CharacterPosition>, map: @Map) -> (Option<u32>, bool) {
        let mut character_index: u32 = 0;
        let mut character_id = 0;
        let OFFSET: u32 = 1000;
        let mut hit_object: bool = false;

        loop {
            if character_index >= characters.len() {
                break;
            }

            let character = *characters.at(character_index);

            //plus 1000 offset to to avoid underflow
            let lower_bound_x = character.coords.x + OFFSET - 500;
            let upper_bound_x = character.coords.x + OFFSET + 500;
            let lower_bound_y = character.coords.y + OFFSET - 500;
            let upper_bound_y = character.coords.y + OFFSET + 500;

            //plus 1000 offset to to match bounds offset            
            if (self.coords.x + OFFSET > lower_bound_x && self.coords.x + OFFSET < upper_bound_x &&
            self.coords.y + OFFSET > lower_bound_y && self.coords.y + OFFSET < upper_bound_y) {
                character_id = character.id;
                break;        
            }

            character_index += 1;
        };
        let x_index = self.coords.x / 4000;
        let y_index = self.coords.y / 4000;
        let index = (x_index + y_index * 25).try_into().unwrap();
        let mut object_index: u32 = 0;
        while object_index.into() < map.map_objects.len() {
            let object = *map.map_objects.at(object_index);
            if object == index {
                hit_object = true;
                break;
            }
            object_index += 1;
        };

        //ignore collision with the player that shot the bullet
        //if hit wall then return no id but true for hit_object
        if character_id == 0 || character_id == self.shot_by {
            return (Option::None(()), hit_object);
        }

        (Option::Some(character_id), true)
    }


}


#[cfg(test)]
mod simulate_tests {

    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use super::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::tests::helpers::{get_test_character_array};
    use octoguns::consts::{BULLET_SPEED, TEN_E_8};
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::types::MapObjects;

    #[test]
   fn test_bullet_sim_y_only()  {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new_empty(1);

        let mut bullet = BulletTrait::new(1, Vec2 { x:300, y:0}, 90 * TEN_E_8, 1);
        let characters = ArrayTrait::new();
        let (new_bullet, id) = bullet.simulate(@characters, @map);
        match new_bullet {
            Option::None => {
                panic!("Should not be none");
            },
            Option::Some(bullet) => {
                assert!(bullet.coords.x == 300, "x should not have changed");
                assert!(bullet.coords.y == BULLET_SPEED, "y should have changed by speed");
            }
        }
    }

    #[test]
    fn test_bullet_sim_x_only()  {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new_empty(1);

         let mut bullet = BulletTrait::new(1, Vec2 { x:0, y:0}, 0, 1);
         let characters = ArrayTrait::new();
         let (new_bullet, id) = bullet.simulate(@characters, @map);
         match new_bullet {
             Option::None => {
                 panic!("Should not be none");
             },
             Option::Some(bullet) => {

                assert!(bullet.coords.x == BULLET_SPEED, "x should have changed by speed");
                assert!(bullet.coords.y == 0, "y should not have changed");
             }
         }
     }


     #[test]
     fn test_collision() {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new_empty(1);
        let mut bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 0, 1);
        let characters = array![CharacterPositionTrait::new(69, Vec2 {x: 14, y: 0})];
        let (new_bullet, res) = bullet.simulate(@characters, @map);
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
        let map = MapTrait::new_empty(1);

        let mut bullet = BulletTrait::new(1, Vec2 { x:700, y:1}, 0, 1);
        let characters = array![CharacterPositionTrait::new(69,Vec2 {x: 4, y: 0})];
        let (new_bullet, res) = bullet.simulate(@characters, @map);
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
     fn test_collision_with_object() {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new(1, MapObjects { objects: array![7]});

        let characters = ArrayTrait::new();
        let mut bullet = BulletTrait::new(1, Vec2 { x:30_000, y:0}, 0, 1);
        let (new_bullet, res) = bullet.simulate(@characters, @map);
        match new_bullet {
            Option::None => {
                match res {
                    Option::None => {
                    },
                    Option::Some(id) => {
                        panic!("should not return id");
                    }
                }
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }

     #[test]
     fn test_collision_with_object_2() {
        let address = starknet::contract_address_const::<0x0>();
        let map = MapTrait::new(1, MapObjects { objects: array![7]});

        let characters = ArrayTrait::new();
        let mut bullet = BulletTrait::new(1, Vec2 { x:27_850, y:0}, 0, 1);
        let (new_bullet, res) = bullet.simulate(@characters, @map);
        match new_bullet {
            Option::None => {
                match res {
                    Option::None => {
                    },
                    Option::Some(id) => {
                        panic!("should not return id");
                    }
                }
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }
}