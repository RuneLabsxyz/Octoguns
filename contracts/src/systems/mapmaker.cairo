#[dojo::interface]
trait IMapmaker {
    fn create(ref world: IWorldDispatcher, grid1: felt252, grid2: felt252, grid3: felt252);
    fn default_map(ref world: IWorldDispatcher);
}

#[dojo::contract]
mod mapmaker {
    use super::IMapmaker;
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::{GLOBAL_KEY};
    use octoguns::lib::bitwise::{pow2_const};
    #[abi(embed_v0)]
    impl MapmakerImpl of IMapmaker<ContractState> {

        fn default_map(ref world: IWorldDispatcher) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            assert!(global.map_count == 0, "Map already exists");
            let map_id = 0;
            let map = MapTrait::new(map_id, pow2_const(7), pow2_const(7), pow2_const(7));
            global.map_count += 1;
            set!(world, (map, global));
        }

        fn create(ref world: IWorldDispatcher, grid1: felt252, grid2: felt252, grid3: felt252) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            assert!(global.map_count != 0, "Must spawn default map first");
            let map_id = global.map_count;
            let map = MapTrait::new(map_id, grid1.try_into().unwrap(), grid2.try_into().unwrap(), grid3.try_into().unwrap());
            global.map_count += 1;
            set!(world, (map, global));
        }
    }
}