#[dojo::interface]
trait IMapMaker {
    fn create(ref world: IWorldDispatcher, objects: Array<u16>);
    fn default_map(ref world: IWorldDispatcher);
}

#[dojo::contract]
mod mapmaker {
    use super::IMapMaker;
    use octoguns::models::map::{Map, MapTrait};
    use octoguns::models::global::{Global, GlobalTrait};
    use octoguns::consts::{GLOBAL_KEY};

    #[abi(embed_v0)]
    impl MapMakerImpl of IMapMaker<ContractState> {

        fn default_map(ref world: IWorldDispatcher) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            assert!(global.map_ids.len() == 0, "Map already exists");
            let map_id = world.uuid();
            let row = 12 * 25;
            // some objects in the middle of the map with some gaps
            let objects: Array<u16> = array![row + 1, row+2, row+3, row+5, row+6, row+7, row+9, row+10, row+ 11];
            let map = MapTrait::new(map_id, objects);
            global.map_ids.append(map_id);
            set!(world, (map, global));
        }

        fn create(ref world: IWorldDispatcher, objects: Array<u16>) {
            let mut global = get!(world, GLOBAL_KEY, (Global));
            assert!(global.map_ids.len() != 0, "Must spawn default map first");
            let map_id = world.uuid();
            let map = MapTrait::new(map_id, objects);
            global.map_ids.append(map_id);
            set!(world, (map, global));
        }
    }
}