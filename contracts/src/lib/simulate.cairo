use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::types::{Vec2};
use octoguns::models::character::{CharacterPosition, CharacterPositionTrait};
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
            Option::Some(bullet) => updated_bullets.append(bullet),
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

    use octoguns::models::character::{CharacterPosition, CharacterPositionTrait};
    use octoguns::models::bullet::{Bullet, BulletTrait};
    use octoguns::types::{Vec2};
    use octoguns::lib::defaultSpawns::{generate_character_positions};
    use super::{simulate_bullets, SimulationResult};

    use octoguns::tests::helpers::{get_test_character_array};
     #[test]
    fn test_4_bullets_sim()  {
        let address = starknet::contract_address_const::<0x0>();

        let bullet_1 = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 180, address);
        let bullet_2 = BulletTrait::new(1, Vec2 { x:3, y:5}, 3, 74, address);
        let bullet_3 = BulletTrait::new(1, Vec2 { x:6, y:1}, 4, 27, address);
        let bullet_4 = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 90, address);

        let mut characters = get_test_character_array();
    
        let mut bullets = array![bullet_1, bullet_2, bullet_3, bullet_4];
        let res = simulate_bullets(ref bullets, ref characters);
         
     }

     #[test]
     fn test_collisions() {
        let address = starknet::contract_address_const::<0x0>();

        let bullet = BulletTrait::new(1, Vec2 { x:3, y:0}, 1, 0, address);
        let mut bullets = array![bullet];
        //todo add more collisions
        let mut characters = array![CharacterPositionTrait::new(69,4,0,100,0)];
        let (mut bullets, mut ids) = simulate_bullets(ref bullets, ref characters);
        match bullets.pop_front() {
            Option::None => {
                let id = ids.pop_front().unwrap();
                assert!(id == 69, "not returning id of hit piece");
            },
            Option::Some(bullet) => {
                panic!("bullet should have collided");
            }
        }
     }
}