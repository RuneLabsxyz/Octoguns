use octoguns::types::{Action};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::character::{CharacterPosition};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

fn shoot(world: IWorldDispatcher, bullet: Action, character: CharacterPosition, player: ContractAddress) -> Bullet {
    let angle = bullet.angle; //u32
    let coords = character.coords; //Vec2
    let speed = 25;
    let id = world.uuid();
    let new_bullet = BulletTrait::new(id, coords, speed, angle, player);

    set!(world, (new_bullet));

    return new_bullet;
}