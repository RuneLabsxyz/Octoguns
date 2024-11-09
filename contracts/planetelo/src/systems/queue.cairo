// define the interface
use planetelo::models::QueueStatus;
#[starknet::interface]
trait IQueue<T> {
    fn queue(ref self: T, game: felt252, playlist: u128);
    fn dequeue(ref self: T, game: felt252, playlist: u128);
    fn matchmake(ref self: T, game: felt252, playlist: u128);
    fn settle(ref self: T, game: felt252, game_id: u128);
    fn get_elo(self: @T, address: starknet::ContractAddress, game: felt252, playlist: u128) -> u64;
    fn get_queue_length(self: @T, game: felt252, playlist: u128) -> u32;
    fn get_status(self: @T, address: starknet::ContractAddress, game: felt252, playlist: u128) -> QueueStatus;
}

// dojo decorator
#[dojo::contract]
mod queue {

    use super::{IQueue};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};
 
    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};


    use planetary_interface::interfaces::one_on_one::{
        IOneOnOneDispatcher, IOneOnOneDispatcherTrait, Status
    };

    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait
    };

    use planetary_interface::utils::systems::{get_world_contract_address};

    use planetelo::models::{PlayerStatus, QueueStatus, Elo, Member, Game, Queue, Player, Global, GlobalTrait};
    use planetelo::elo::EloTrait;
    use planetelo::consts::ELO_DIFF;
    use planetelo::helpers::helpers::{find_match, get_planetelo_dispatcher, update_elos, get_queue_members};
    use planetelo::helpers::queue_update::update_queue;

    #[abi(embed_v0)]
    impl QueueImpl of IQueue<ContractState> {
        

        fn queue(ref self: ContractState, game: felt252, playlist: u128) {
            let address = get_caller_address();
            let mut world = self.world(@"planetelo");
            let mut player: PlayerStatus = world.read_model((address, game, playlist));
            let mut elo: Elo = world.read_model((address, game, playlist));
            let mut player_model: Player = world.read_model((address));
            if elo.value == 0 {
                elo.value = 800;
                world.write_model(@elo);
            }

            let mut global: Global = world.read_model(0);
            let id = global.uuid();

            assert!(player.status == QueueStatus::None, "Player is already in the queue");
            player_model.queues_joined += 1;

            let mut queue: Queue = world.read_model((game, playlist));
            
            let new = Member {
                id: id.into(),
                player: address,
                timestamp: get_block_timestamp(),
                elo: elo.value
            };

            queue.members.append(id);

            player.status = QueueStatus::Queued;

            world.write_model(@player_model);
            world.write_model(@player);
            world.write_model(@new);
            world.write_model(@queue);
            world.write_model(@global);
            
        }


        fn dequeue(ref self: ContractState, game: felt252, playlist: u128) {
            let address = get_caller_address();
            let mut world = self.world(@"planetelo");

            let mut player: PlayerStatus = world.read_model((address, game));

            //todo
        }

        fn matchmake(ref self: ContractState, game: felt252, playlist: u128) {
            let address = get_caller_address();
            let mut world = self.world(@"planetelo");

            let mut player_status: PlayerStatus = world.read_model((address, game, playlist));

            assert!(player_status.status != QueueStatus::None, "Player is not in the queue");
            let timestamp = get_block_timestamp();

            let mut p1: Member = world.read_model((game, playlist, player_status.index));
            let time_diff = timestamp - p1.timestamp;
            let time_diff_secs = time_diff;
            assert!(time_diff_secs > 30, "Must be in queue for at least 30 seconds to refresh");

            let mut queue: Queue = world.read_model((game, playlist));
            assert!(queue.members.len() > 1, "There must be at least 2 players in the queue to matchmake");

            let mut status: QueueStatus = QueueStatus::None;

            let mut p2: Member = Member { id: 0, player: contract_address_const::<0x0>(), timestamp: 0, elo: 0 };

            let mut members = get_queue_members(world, game, playlist);
            let maybe_match = find_match(ref members, ref p1);

            match maybe_match {
                Option::Some(match_member) => {
                    p2 = match_member;
                },
                Option::None => {
                    panic!("No match found");
                }
            }

            let dispatcher = get_planetelo_dispatcher(game);
            let p1_address = @p1.player;
            let p2_address = @p2.player;

            let game_id = dispatcher.create_match(  *p1_address, *p2_address, playlist);

            status = QueueStatus::InGame(game_id);
            
            let mut opponent_status: PlayerStatus = world.read_model((p2.player, game, playlist));

            player_status.status = status;
            opponent_status.status = status;

            let new_ids = update_queue(ref world, game, playlist, ref p1, ref p2);
            queue.members = new_ids;

            let game_model: Game = Game {
                game,
                playlist,
                player1: p1.player,
                player2: p2.player,
                id: game_id,
                timestamp: get_block_timestamp()
            };

            world.write_model(@game_model);
            world.write_model(@queue);
            world.write_model(@player_status);
            world.write_model(@opponent_status);
            
        }

        fn settle(ref self: ContractState, game: felt252, game_id: u128) {

            let mut world = self.world(@"planetelo");

            let mut game_model: Game = world.read_model((game, game_id));


            let planetary: IPlanetaryActionsDispatcher = PlanetaryInterfaceTrait::new().dispatcher();
            let contract_address = get_world_contract_address(IWorldDispatcher {contract_address: planetary.get_world_address(game)}, selector_from_tag!("planetelo-planetelo"));
            
            let dispatcher = IOneOnOneDispatcher{ contract_address };

            let status = dispatcher.settle_match(game_id);
            
            let mut player_one: PlayerStatus = world.read_model((game_model.player1, game_model.game, game_model.playlist));
            let mut player_two: PlayerStatus = world.read_model((game_model.player2, game_model.game, game_model.playlist));
            
            let mut player_one_elo: Elo = world.read_model((game_model.player1, game_model.game, game_model.playlist));
            let mut one_elo: u64 = player_one_elo.value;
            
            let mut player_two_elo: Elo = world.read_model((game_model.player2, game_model.game, game_model.playlist));
            let mut two_elo: u64 = player_two_elo.value;

            let (mag, sign) = EloTrait::rating_change(800_u64, 800_u64, 50_u16, 20_u8);

            let (new_one_elo, new_two_elo) = update_elos(status, @game_model, ref one_elo, ref two_elo);

            player_one_elo.value = new_one_elo;
            player_two_elo.value = new_two_elo;
            player_one.status = QueueStatus::None;
            player_two.status = QueueStatus::None;

            world.write_model(@player_one_elo);
            world.write_model(@player_two_elo);
            world.write_model(@player_one);
            world.write_model(@player_two);
            
        }

        fn get_elo(self: @ContractState, address: ContractAddress, game: felt252, playlist: u128) -> u64 {
            let world = self.world(@"planetelo");
            let elo: Elo = world.read_model((address, game, playlist));
            elo.value
        }

        fn get_queue_length(self: @ContractState, game: felt252, playlist: u128) -> u32 {
            let world = self.world(@"planetelo");
            let queue: Queue = world.read_model((game, playlist));
            queue.members.len()
        }

        fn get_status(self: @ContractState, address: ContractAddress, game: felt252, playlist: u128) -> QueueStatus {
            let world = self.world(@"planetelo");
            let player: PlayerStatus = world.read_model((address, game, playlist));
            player.status
        }

    }
}
