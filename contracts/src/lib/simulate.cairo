use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::types::{Vec2};
use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
use alexandria_math::trigonometry::{fast_cos, fast_sin};
use octoguns::consts::TEN_E_8;

// Tuple to hold both bullets and character positions
pub type SimulationResult = (Array<Bullet>, Array<u32>);

pub fn simulate_bullets(ref bullets: Array<Bullet>, ref character_positions: Array<CharacterPosition>) -> SimulationResult {
    let mut updated_bullets = ArrayTrait::new();
    let mut dead_characters_ids = ArrayTrait::new();
    let mut character_index: u32 = 0;

    loop {
        if character_index >= bullets.len() {
            break;
        }
        let mut bullet = *bullets.at(character_index);
        let (updated_bullet, character_id) = bullet.simulate(@character_positions);
        match updated_bullet {
            Option::Some(bullet) => {
                println!("bullet ({}, {}) angle {}", bullet.coords.x, bullet.coords.y, bullet.angle);
                updated_bullets.append(bullet)
            },
            Option::None => {},
        }
        if character_id != 0 {
            // Only append character if not hit
                dead_characters_ids.append(character_id);
        }
        character_index += 1;
    };

    (updated_bullets, dead_characters_ids)
}

#[cfg(test)]
mod simulate_tests {

    use octoguns::models::characters::{CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::lib::default_spawns::{generate_character_positions};
    use octoguns::consts::TEN_E_8;
    use super::{simulate_bullets, SimulationResult};

    use octoguns::tests::helpers::{get_test_character_array};

    #[test]
    fn test_4_bullets_sim()  {
        let address = starknet::contract_address_const::<0x0>();

        let bullet_1 = BulletTrait::new(1, Vec2 { x:300, y:0}, 180 * TEN_E_8, address);
        let bullet_2 = BulletTrait::new(1, Vec2 { x:300, y:555}, 100 * TEN_E_8, address);
        let bullet_3 = BulletTrait::new(1, Vec2 { x:6, y:1}, 4 * TEN_E_8, address);
        let bullet_4 = BulletTrait::new(1, Vec2 { x:3, y:0}, 90 * TEN_E_8, address);

        let mut characters = get_test_character_array();
    
        let mut bullets = array![bullet_1, bullet_2, bullet_3, bullet_4];
        let res = simulate_bullets(ref bullets, ref characters);
    }

    #[test]
    fn test_no_collisions() {
        let address = starknet::contract_address_const::<0x0>();

        let bullet = BulletTrait::new(1, Vec2 { x: 0, y: 0 }, 0, address);
        let mut bullets = array![bullet];
        let mut characters = array![
            CharacterPositionTrait::new(1, Vec2 { x: 0, y: 75 }),
            CharacterPositionTrait::new(2, Vec2 { x: 458, y: 234 })
        ];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters);

        assert!(updated_bullets.len() == 1, "Bullet should not be removed");
        assert!(dead_characters_ids.is_empty(), "No characters should be hit");
    }

    #[test]
    fn test_multiple_collisions() {
        let address = starknet::contract_address_const::<0x0>();
        let mut bullets = array![];
        let mut characters = array![

        ];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters);

    }

    #[test]
    fn test_bullet_out_of_bounds() {
        let address = starknet::contract_address_const::<0x0>();

        let bullet = BulletTrait::new(1, Vec2 { x: 9950, y: 9950 }, 0, address);
        let mut bullets = array![bullet];
        let mut characters = array![CharacterPositionTrait::new(1, Vec2 { x: 0, y: 0 })];

        let (updated_bullets, dead_characters_ids) = simulate_bullets(ref bullets, ref characters);

        assert!(updated_bullets.is_empty(), "Bullet should be removed when out of bounds");
        assert!(dead_characters_ids.is_empty(), "No characters should be hit");
    }
}