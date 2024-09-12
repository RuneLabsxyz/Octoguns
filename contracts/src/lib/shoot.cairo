use octoguns::types::{Shot};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::characters::{CharacterPosition};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

fn shoot(world: IWorldDispatcher, shot: Shot, character: CharacterPosition, shot_by: u32) -> Bullet {
    let angle = shot.angle; //u32
    let coords = character.coords; //Vec2
    let id = world.uuid();
    let new_bullet = BulletTrait::new(id, coords, angle, shot_by);

    set!(world, (new_bullet));

    return new_bullet;
}