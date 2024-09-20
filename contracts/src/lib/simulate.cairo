use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::types::{Vec2};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use alexandria_math::trigonometry::{fast_cos, fast_sin};
use octoguns::consts::TEN_E_8;
use octoguns::models::map::{Map, MapTrait};

// Tuple to hold both bullets and character positions
pub type SimulationResult = (Array<Bullet>, Array<u32>);

pub fn simulate_bullets(ref bullets: Array<Bullet>, ref character_positions: Array<CharacterPosition>, map: @Map, step: u32) -> SimulationResult {
    let mut updated_bullets = ArrayTrait::new();
    let mut dead_characters_ids = ArrayTrait::new();
    
    loop {
        match bullets.pop_front() {
            Option::Some(mut bullet) => {
                let (updated_bullet, hit_character) = bullet.simulate(@character_positions, map, step);
                match updated_bullet {
                    Option::Some(bullet) => {
                        updated_bullets.append(bullet)
                    },
                    Option::None => {
                        match hit_character {
                            Option::Some(character_id) => {
                                dead_characters_ids.append(character_id);
                            },
                            Option::None => {},
                        }
                    },
                }
            },
            Option::None => {break;},
        }
        
    };

    (updated_bullets, dead_characters_ids)
}

#[cfg(test)]
mod simulate_tests {

    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::types::{Vec2};
    use octoguns::lib::default_spawns::{generate_character_positions};
    use octoguns::consts::TEN_E_8;
    use super::{simulate_bullets, SimulationResult};

    use octoguns::tests::helpers::{get_test_character_array};

    #[test]
    fn test_4_bullets_sim()  {
        let address = starknet::contract_address_const::<0x0>();

        let map = MapTrait::new_empty(1);

        let bullet_1 = BulletTrait::new(1, Vec2 { x:300, y:0}, 180 * TEN_E_8, 1);
        let bullet_2 = BulletTrait::new(1, Vec2 { x:300, y:555}, 100 * TEN_E_8, 2);
        let bullet_3 = BulletTrait::new(1, Vec2 { x:6, y:1}, 4 * TEN_E_8, 3);
        let bullet_4 = BulletTrait::new(1, Vec2 { x:3, y:0}, 90 * TEN_E_8, 4);

        let mut characters = get_test_character_array();
        
        let mut bullets = array![bullet_1, bullet_2, bullet_3, bullet_4];
        let res = simulate_bullets(ref bullets, ref characters, @map);
    }

    #[test]
    fn test_no_collisions() {
        let address = starknet::contract_address_const::<0x0>();

        let map = MapTrait::new_empty(1);

        let bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 0, 63);
        let mut bullets = array![bullet];
        let mut characters = array![
            CharacterPositionTrait::new(1, Vec2 { x: 0, y: 75000 }),
            CharacterPositionTrait::new(2, Vec2 { x: 45800, y: 23400 })
        ];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters, @map);

        assert!(updated_bullets.len() == 1, "Bullet should not be removed");
        assert!(dead_characters_ids.is_empty(), "No characters should be hit");
    }

    #[test]
    fn test_multiple_collisions() {
        let address = starknet::contract_address_const::<0x0>();

        let map = MapTrait::new_empty(1);
        let mut bullets = array![];
        let mut characters = array![

        ];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters, @map);

    }

    #[test]
    fn test_bullet_out_of_bounds() {
        let address = starknet::contract_address_const::<0x0>();

        let bullet = BulletTrait::new(1, Vec2 { x: 99999, y: 9950 }, 0, 1);
        let map = MapTrait::new_empty(1);
        let mut bullets = array![bullet];
        let mut characters = array![CharacterPositionTrait::new(1, Vec2 { x: 0, y: 0 })];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters, @map);

        assert!(updated_bullets.is_empty(), "Bullet should be removed when out of bounds");
        assert!(dead_characters_ids.is_empty(), "No characters should be hit");
    }
}