use octoguns::types::{Shot};
use octoguns::models::bullet::{Bullet, BulletTrait};
use octoguns::models::characters::{CharacterPosition};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;

fn shoot(world: IWorldDispatcher, shot: Shot, character: CharacterPosition, player: ContractAddress) -> Bullet {
    let angle = shot.angle; //u32
    let coords = character.coords; //Vec2
    let id = world.uuid();
    let new_bullet = BulletTrait::new(id, coords, angle, player);

    set!(world, (new_bullet));

    return new_bullet;
}