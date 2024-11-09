use dojo::world::storage::{WorldStorage};
use planetelo::models::{QueueMember, Queue, QueueStatus};
use dojo::model::{ModelStorage, ModelValueStorage, Model};
use starknet::contract_address_const;


fn update_queue(ref world: WorldStorage, game: felt252, playlist: u128, ref p1: QueueMember, ref p2: QueueMember) {
    let mut queue: Queue = world.read_model((game, playlist));

    let mut new_member_ids: Array<u128> = ArrayTrait::new();
    let queue_length = queue.length; 

    let last_index = queue_length - 1;
    let second_last_index = queue_length - 2;

    let mut end_updated: bool = false;
    let mut second_end_updated: bool = false;

    let mut p_at_end: bool = false;
    let mut p_at_2end: bool = false;

    let mut p1_updated: bool = false;
    let mut p2_updated: bool = false;


    //if they are at the end, just delete
    if p1.index == last_index || p1.index == second_last_index {
        world.erase_model(@p1);
        p1_updated = true;
        if p1.index == last_index {
            p_at_end = true;
        }
        else if p1.index == second_last_index {
            p_at_2end = true;
        }
    }
    if p2.index == last_index || p2.index == second_last_index {
        world.erase_model(@p2);
        p2_updated = true;
        if p2.index == last_index {
            p_at_end = true;
        }
        else if p2.index == second_last_index {
            p_at_2end = true;
        }
    }


    let mut last_member: QueueMember = world.read_model((game, playlist, last_index));
    let mut last2_member: QueueMember = world.read_model((game, playlist, second_last_index));

    let mut i = 0;
    let mut member: QueueMember = world.read_model((game, playlist, i));

    let mut member_id = 0;

    if p_at_end && p_at_2end {
        queue.length -= 2;
        world.write_model(queue);
        return;
    }
    else if p_at_end {
        // the last player was already deleted, but the second last was not
        // we take the other player that was at the end and move them to the other player's spot
        //then we delete the second last player
        // if p1 was updated, then we know p2 was not   
        // if p2 was updated, then we know p1 was not
        if p1_updated {
            p2.player = last_member.player;
            p2.elo = last_member.elo;
            p2.timestamp = last_member.timestamp;

            last_member.player = contract_address_const::<0x0>();
            last_member.elo = 0;
            last_member.timestamp = 0;
        }
        else if p2_updated {
            p1.player = last_member.player;
            p1.elo = last_member.elo;
            p1.timestamp = last_member.timestamp;

            last_member.player = contract_address_const::<0x0>();
            last_member.elo = 0;
            last_member.timestamp = 0;
        }
        else {
            panic!("no player updated, but p_at_end is true");
        }

        world.erase_model(@last_member);
        world.write_model(@p1);
    }
    else if 

    while i < length {
                member_id = *members[i];
                let mut member: Member = world.read_model((game, playlist, member_id));

                if (member.id != p1.id && member.id != p2.id && !p_at_end) {
                    //if both are not in the last two positions, move last 2 positions to their spots and delelete the last 2 positions
                    p1.player = last_member.player;
                    p1.elo = last_member.elo;
                    p1.timestamp = last_member.timestamp;

                    last_member.player = contract_address_const::<0x0>();
                    last_member.elo = 0;
                    last_member.timestamp = 0;

                    p2.player = last2_member.player;
                    p2.elo = last2_member.elo;
                    p2.timestamp = last2_member.timestamp;

                    last2_member.player = contract_address_const::<0x0>();
                    last2_member.elo = 0;
                    last2_member.timestamp = 0;

                    world.erase_model(@last_member);
                    world.erase_model(@last2_member);
                    world.write_model(@p2);
                    world.write_model(@p1);
                    
                }
                else if (member.id == p1.id) {
                        if (!end_updated && !p1_updated) {
                            p1.player = last_member.player;
                            p1.elo = last_member.elo;
                            p1.timestamp = last_member.timestamp;                            end_updated = true;
                            p1_updated = true;
                            world.erase_model(@last_member);
                            world.write_model(@p1);
                        }
                        else if (!second_end_updated && !p1_updated) {
                            p1.player = last2_member.player;
                            p1.elo = last2_member.elo;
                            p1.timestamp = last2_member.timestamp;                            second_end_updated = true;
                            p1_updated = true;
                            world.erase_model(@last2_member);
                            world.write_model(@p1);
                        }
                        else {
                            panic!("p1 not updated");
                        }
                }
                else if (member.id == p2.id) {
                    if (!end_updated && !p2_updated) {
                        p2.player = last_member.player;
                        p2.elo = last_member.elo;
                        p2.timestamp = last_member.timestamp;                        end_updated = true;
                        p2_updated = true;
                        world.erase_model(@last_member);
                        world.write_model(@p2);
                    }
                    else if (!second_end_updated && !p2_updated) {
                        p2.player = last2_member.player;
                        p2.elo = last2_member.elo;
                        p2.timestamp = last2_member.timestamp;                        second_end_updated = true;
                        p2_updated = true;
                        world.erase_model(@last2_member);
                        world.write_model(@p2);
                    }
                    else {
                        panic!("p2 not updated");
                    }

                    if (member.id != p1.id && member.id != p2.id) {
                        new_member_ids.append(member.id);
                    }
                }
                
              
                i+=1;
    };

    new_member_ids



}