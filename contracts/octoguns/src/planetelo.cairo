use planetelo_interface::interfaces::octoguns::Settings;
use octoguns::consts::GLOBAL_KEY;
use starknet::ContractAddress;

#[derive(Drop, Serde)]
#[dojo::model]
struct Playlist {
    #[key]
    id: u128,
    maps: Array<u32>,
    settings: Settings
}


#[derive(Copy, Drop, Serde)]
#[dojo::model]
struct PlaylistGlobal {
    #[key]
    global_key: u32,
    playlist_count: u32
}

//planetelo 1on1 interface
#[starknet::interface]
pub trait IOneOnOne<TState> {
    fn create_match(ref self: TState, p1: ContractAddress, p2: ContractAddress, playlist_id: u128) -> u128;
    fn settle_match(ref self: TState, match_id: u128) -> Status;
}

#[derive(Drop, Serde)]
pub enum Status {
    None,
    Active,
    Draw,
    Winner: ContractAddress,

}

#[starknet::interface]
trait IPlanetelo<T> {
    fn create_playlist(self: @T, maps: Array<u32>, settings: Settings) -> u32;
    fn spawn_default_playlist(self: @T);

}

#[dojo::contract]
mod planetelo {
    use octoguns::consts::GLOBAL_KEY;
    use super::{Playlist, PlaylistGlobal, IPlanetelo};
    use planetelo_interface::interfaces::planetelo::{IOneOnOne, Status};
    use planetelo_interface::interfaces::octoguns::{
        OctogunsTrait, Octoguns,
        IOctogunsStartDispatcher, IOctogunsStartDispatcherTrait, Settings};
    use octoguns::lib::dice::{Dice, DiceTrait, DiceImpl};
    use octoguns::models::sessions::{Session, SessionMeta};
    use starknet::{ContractAddress, get_block_timestamp};
    use dojo::world::{WorldStorage, WorldStorageTrait};

    use dojo::model::{ModelStorage, ModelValueStorage, Model};


    #[abi(embed_v0)]
    impl PlaneteloInterfaceImpl of IPlanetelo<ContractState> {
        fn create_playlist(self: @ContractState, maps: Array<u32>, settings: Settings) -> u32 {
            let mut world = self.world(@"planetelo");
            let mut global: PlaylistGlobal = world.read_model(GLOBAL_KEY);
            assert!(global.playlist_count > 0, "Spawn Default First");
            let id = global.playlist_count;
            global.playlist_count += 1;

            let playlist = Playlist {
                id: id.into(),
                maps,
                settings
            };
            world.write_model(@playlist);
            world.write_model(@global);
            id
        }

        fn spawn_default_playlist(self: @ContractState) {
            let mut world = self.world(@"planetelo");
            let mut global: PlaylistGlobal = world.read_model(GLOBAL_KEY);
            assert!(global.playlist_count == 0, "Playlist already exists");

            let maps = array![0];
            let settings = Settings {
                bullet_speed: 300,
                bullet_sub_steps: 3,
                bullets_per_turn: 1,
                sub_moves_per_turn: 100,
                max_distance_per_sub_move: 400,
            };
            let playlist: Playlist = Playlist {
                id: 0,
                maps,
                settings
            };
            world.write_model(@playlist);
            global.playlist_count = 1;
            world.write_model(@global);
        }
    }

    #[abi(embed_v0)]
    impl OneOnOneImpl of IOneOnOne<ContractState> {
        fn create_match(ref self: ContractState, p1: ContractAddress, p2: ContractAddress, playlist_id: u128) -> u128{
            let mut world = self.world(@"planetelo");
            let mut octoguns = self.world(@"octoguns");
            let (contract_address, _) = octoguns.dns(@"start").unwrap();
            let start_dispatcher = IOctogunsStartDispatcher {contract_address};

            let global: PlaylistGlobal = world.read_model(GLOBAL_KEY);
            assert!(playlist_id < global.playlist_count.into(), "Playlist does not exist");

            let playlist: Playlist = world.read_model(playlist_id);

            let map_count = playlist.maps.len();

            let seed: felt252 = starknet::get_block_timestamp().into();
            let mut dice = DiceTrait::new(map_count, seed);
            let map_index = dice.roll() - 1;

            let map_id = playlist.maps[map_index];

            let id: u128 = start_dispatcher.create_closed(*map_id, p1, p2, playlist.settings).into();
            id
        }

        fn settle_match(ref self: ContractState, match_id: u128) -> Status {
            let mut world = self.world(@"octoguns");
            let session: Session = world.read_model(match_id);
            let session_meta: SessionMeta = world.read_model(match_id);

            if (session.player1 == session.player2) {
                panic!("Player 1 and Player 2 are the same");
                return Status::Draw;
            }

            match session.state {
                0 => {
                    Status::None
                },
                1 => {
                    Status::Active
                },
                2 => {
                    Status::Active
                },
                3 => {
                    if session_meta.p1_character == 0 && session_meta.p2_character == 0 {
                        panic!("both ids 0");
                        Status::Draw
                    } else if session_meta.p1_character == 0 {
                        Status::Winner(session.player2)
                    } else if session_meta.p2_character == 0 {
                        Status::Winner(session.player1)
                    } else {
                        Status::Draw
                    }
                },
                _ => {
                    Status::None
                }
            }
        }
    }
}


