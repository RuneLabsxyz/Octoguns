use octoguns::types::Vec2;
use starknet::ContractAddress;

#[derive(Clone, Drop, Serde)]
#[dojo::model]
pub struct Map {
    #[key]
    pub map_id: u32,
    pub grid1: u256,
    pub grid2: u256,
    pub grid3: u256,
}

#[generate_trait]
impl MapImpl of MapTrait {
    fn new(map_id: u32, grid1: u256, grid2: u256, grid3: u256) -> Map {
        Map {map_id, grid1, grid2, grid3}
    }

    fn new_empty(map_id: u32) -> Map {
        Map {map_id, grid1: 0, grid2: 0, grid3: 0}
    }
}

