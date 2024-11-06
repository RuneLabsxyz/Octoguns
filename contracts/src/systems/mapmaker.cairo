#[starknet::interface]
trait IMapmaker<T> {
    fn create(self: @T, grid1: felt252, grid2: felt252, grid3: felt252);
    fn default_map(self: @T);
}

#[dojo::contract]
mod mapmaker {
    use super::IMapmaker;
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::{GLOBAL_KEY};
    use octoguns::lib::bitwise::{pow2_const};
    use dojo::model::{ModelStorage, ModelValueStorage, Model};


    #[abi(embed_v0)]
    impl MapmakerImpl of IMapmaker<ContractState> {

        fn default_map(self: @ContractState) {
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            assert!(global.map_count == 0, "Map already exists");
            let map_id = 0;
            let map = MapTrait::new(map_id, pow2_const(7), pow2_const(7), pow2_const(7));
            global.map_count += 1;
            world.write_model(@map);
            world.write_model(@global);
        }

        fn create(self: @ContractState, grid1: felt252, grid2: felt252, grid3: felt252) {
            let mut world = self.world(@"octoguns");
            let mut global: Global = world.read_model(GLOBAL_KEY);
            assert!(global.map_count != 0, "Must spawn default map first");
            let map_id = global.map_count;
            let map = MapTrait::new(map_id, grid1.try_into().unwrap(), grid2.try_into().unwrap(), grid3.try_into().unwrap());
            global.map_count += 1;
            world.write_model(@map);
            world.write_model(@global);
        }
    }
}