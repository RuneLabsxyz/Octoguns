// define the interface
use planetary_interface::interfaces::one_on_one::{Status};

#[starknet::interface]
trait IQueue<T> {
    fn queue(ref self: T, game: felt252, playlist: u128);
    fn dequeue(ref self: T, game: felt252, playlist: u128);
    fn matchmake(ref self: T, game: felt252, playlist: u128);
    fn settle(ref self: T, game: felt252, game_id: u128);
    fn get_elo(self: @T, address: starknet::ContractAddress, game: felt252, playlist: u128) -> u64;
    fn get_queue_length(self: @T, game: felt252, playlist: u128) -> u32;
    fn get_status(self: @T, address: starknet::ContractAddress, game: felt252, playlist: u128) -> Status;
}

// dojo decorator
#[dojo::contract]
mod queue {

    use super::{IQueue};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};
    use planetary_interface::interfaces::planetary::{
        PlanetaryInterface, PlanetaryInterfaceTrait,
        IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
    };
    use dojo::model::{ModelStorage, ModelValueStorage, Model};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};


    use planetary_interface::interfaces::one_on_one::{
        IOneOnOneDispatcher, IOneOnOneDispatcherTrait, Status
    };

    use planetary_interface::utils::systems::{get_world_contract_address};

    use planetelo::models::{PlayerStatus, QueueStatus, Elo, QueueIndex, Game, Queue, Player};
    use planetelo::elo::EloTrait;

    use planetelo::consts::ELO_DIFF;

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

            assert!(player.status == QueueStatus::None, "Player is already in the queue");
            player_model.queues_joined += 1;

            let mut queue: Queue = world.read_model((game, playlist));
            
            let new = QueueIndex {
                game: game,
                playlist: playlist,
                index: queue.length,
                player: address,
                timestamp: get_block_timestamp(),
                elo: elo.value
            };

            queue.length += 1;
            player.status = QueueStatus::Queued;

            world.write_model(@player_model);
            world.write_model(@player);
            world.write_model(@new);
            world.write_model(@queue);
            
        }


        fn dequeue(ref self: ContractState, game: felt252, playlist: u128) {
            let address = get_caller_address();
            let mut world = self.world(@"planetelo");

            let mut player: PlayerStatus = world.read_model((address, game));

            assert!(player.status == QueueStatus::Queued, "Player is not in the queue");

            let mut queue: Queue = world.read_model((game, playlist));
            let mut index: QueueIndex = world.read_model((game, playlist, player.index));
            let mut last_index: QueueIndex = world.read_model((game, playlist, queue.length - 1));

            index.player = last_index.player;
            index.index = last_index.index;
            index.timestamp = last_index.timestamp;
            index.elo = last_index.elo;

            queue.length -= 1;
            player.status = QueueStatus::None;

            world.erase_model(@last_index);
            world.write_model(@player);
            world.write_model(@index);
            world.write_model(@queue);
        }

        fn matchmake(ref self: ContractState, game: felt252, playlist: u128) {
            let address = get_caller_address();
            let mut world = self.world(@"planetelo");

            let mut player_status: PlayerStatus = world.read_model((address, game, playlist));

            assert!(player_status.status != QueueStatus::None, "Player is not in the queue");
            let timestamp = get_block_timestamp();

            let mut player_index: QueueIndex = world.read_model((game, playlist, player_status.index));
            let time_diff = timestamp - player_index.timestamp;
            let time_diff_secs = time_diff;
            println!("time_diff_secs: {}", time_diff_secs);
            assert!(time_diff_secs > 30, "Must be in queue for at least 30 seconds to refresh");

            let mut queue: Queue = world.read_model((game, playlist));
            assert!(queue.length > 1, "There must be at least 2 players in the queue to matchmake");
            let mut potential_index = player_index;
            let mut i = 0;
            let mut found = false;
            while i < queue.length {
                let potential_index: QueueIndex = world.read_model((game, playlist, i));
                if potential_index.player == player_index.player {
                    i+=1;
                    continue;
                }
                if potential_index.elo > player_index.elo {
                    if potential_index.elo - player_index.elo > ELO_DIFF {
                        i+=1;
                        continue;
                    }
                    else {
                        found = true;
                        break;
                    }
                } 
                else {
                    if player_index.elo - potential_index.elo > ELO_DIFF {
                        i+=1;
                        continue;
                    }
                    else {
                        found = true;
                        break;
                    }
                }
            };

            assert!(found, "No match found");

            let planetary: IPlanetaryActionsDispatcher = PlanetaryInterfaceTrait::new().dispatcher();
            let contract_address = get_world_contract_address(IWorldDispatcher {contract_address: planetary.get_world_address(game)}, selector_from_tag!("planetelo-planetelo"));
            
            let dispatcher = IOneOnOneDispatcher{ contract_address };

            let game_id = dispatcher.create_match(  player_index.player, potential_index.player, playlist);

            player_status.status = QueueStatus::InGame(game_id);

            let mut potential_status: PlayerStatus = world.read_model((potential_index.player, game, playlist));
            potential_status.status = QueueStatus::InGame(game_id);

            let game_model = Game {
                game: game,
                id: game_id,
                playlist: playlist,
                player1: address,
                player2: potential_index.player,
                timestamp: timestamp
            };

            let last_index = queue.length - 1;
            let second_last_index = queue.length -2;

            let mut last_player: QueueIndex = world.read_model((game, playlist, last_index));
            let mut second_last_player: QueueIndex = world.read_model((game, playlist, second_last_index));

            let mut replacing = QueueIndex { game, playlist, index: 0, player: contract_address_const::<0x0>(), elo: 0, timestamp: 0 };

            //if both are not in the last two positions, move last 2 positions to their spots and delelete the last 2 positions
            if player_index.index < queue.length - 2 && potential_index.index < queue.length - 2 {

                player_index.player = last_player.player;
                player_index.elo = last_player.elo;
                player_index.timestamp = last_player.timestamp;

                last_player.player = contract_address_const::<0x0>();
                last_player.elo = 0;
                last_player.timestamp = 0;

                potential_index.player = second_last_player.player;
                potential_index.elo = second_last_player.elo;
                potential_index.timestamp = second_last_player.timestamp;

                second_last_player.player = contract_address_const::<0x0>();
                second_last_player.elo = 0;
                second_last_player.timestamp = 0;

                world.write_model(@last_player);
                world.write_model(@second_last_player);
                world.write_model(@player_index);
                world.write_model(@potential_index);
                
            }

            //if one is in the last two positions, move that player to the spot of the player who is in game and delete the last position
            else if player_index.index < queue.length - 2 {
                if potential_index.index == queue.length - 2 {
                    let mut replacing = last_player;
                }
                else if potential_index.index == queue.length - 1 {
                    let mut replacing = second_last_player;
                }

                

                player_index.player = replacing.player;
                player_index.elo = replacing.elo;
                player_index.timestamp = replacing.timestamp;
                world.write_model(@player_index);
                world.erase_model(@replacing);
                world.erase_model(@potential_index);
            }

            else if potential_index.index < queue.length - 2 {
                if player_index.index == queue.length - 2 {
                    let mut replacing = last_player;
                }
                else if player_index.index == queue.length - 1 {
                    let mut replacing = second_last_player;
                }

                potential_index.player = replacing.player;
                potential_index.elo = replacing.elo;
                potential_index.timestamp = replacing.timestamp;
                world.write_model(@potential_index);
                world.erase_model(@replacing);
                world.erase_model(@player_index);
            }

            else {
                world.erase_model(@player_index);
                world.erase_model(@potential_index);
            }


            queue.length -= 2;
            world.write_model(@player_status);
            world.write_model(@potential_status);
            world.write_model(@game_model);
            world.write_model(@queue);
            

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
            let one_elo: u64 = player_one_elo.value;
            let mut player_two_elo: Elo = world.read_model((game_model.player2, game_model.game, game_model.playlist));
            let two_elo: u64 = player_two_elo.value;

            let (mag, sign) = EloTrait::rating_change(800_u64, 800_u64, 50_u16, 20_u8);


            match status {
                Status::None => {
                    panic!("Match has doesn't exist");
                },
                Status::Active => {
                    panic!("Match is still active");
                },
                Status::Draw => {

                    let (mag, sign) = EloTrait::rating_change(one_elo, two_elo, 50_u16, 20_u8);


                    if sign {
                        player_one_elo.value += mag;
                        player_two_elo.value -= mag;
                    }
                    else {
                        player_one_elo.value -= mag;
                        player_two_elo.value += mag;
                    }
                    

                    player_one.status = QueueStatus::None;
                    player_two.status = QueueStatus::None;

                    world.write_model(@player_one);
                    world.write_model(@player_two);
                    world.write_model(@player_one_elo);
                    world.write_model(@player_two_elo);
                },
                Status::Winner(winner) => {

                    let mut did_win: u16 = 0;

                    if winner == game_model.player1 {
                        did_win = 100;
                    }

                    let (mag, sign) = EloTrait::rating_change(one_elo, two_elo, did_win, 20_u8);

                    if sign {
                        player_one_elo.value += mag;
                        player_two_elo.value -= mag;
                    }
                    else {
                        player_one_elo.value -= mag;
                        player_two_elo.value += mag;
                    }
                    
                    player_one.status = QueueStatus::None;
                    player_two.status = QueueStatus::None;

                    world.write_model(@player_one);
                    world.write_model(@player_two);
                    world.write_model(@player_one_elo);
                    world.write_model(@player_two_elo);

                }
            }
            
            
        }

        fn get_elo(self: @ContractState, address: ContractAddress, game: felt252, playlist: u128) -> u64 {
            let world = self.world(@"planetelo");
            let elo: Elo = world.read_model((address, game, playlist));
            elo.value
        }

        fn get_queue_length(self: @ContractState, game: felt252, playlist: u128) -> u32 {
            let world = self.world(@"planetelo");
            let queue: Queue = world.read_model((game, playlist));
            queue.length
        }

        fn get_status(self: @ContractState, address: ContractAddress, game: felt252, playlist: u128) -> Status {
            let world = self.world(@"planetelo");
            let player: PlayerStatus = world.read_model((address, game, playlist));
            player.status
        }

    }
}
