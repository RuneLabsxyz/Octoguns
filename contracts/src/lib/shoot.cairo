use octoguns::types::{Action, CharacterPosition};
use octoguns::models::bullet::{Bullet, BulletTrait};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

fn shoot(world: IWorldDispatcher, bullet: Action, character: CharacterPosition, player: ContractAddress) -> Bullet {
    let angle = bullet.action_type; //u32
    let coords = character.coords; //Vec2
    let speed = 25;
    let id = world.uuid();
    let new_bullet = BulletTrait::new(id, coords, speed, angle, player);

    set!(world, (new_bullet));

    return new_bullet;
}