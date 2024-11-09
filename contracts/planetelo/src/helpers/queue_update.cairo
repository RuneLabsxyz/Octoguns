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
    let mut second_last_member: QueueMember = world.read_model((game, playlist, second_last_index));

    let mut i = 0;
    let mut member: QueueMember = world.read_model((game, playlist, i));

    let mut member_id = 0;

    if p_at_end && p_at_2end {
        queue.length -= 2;
        world.write_model(@queue);
        return;
    }


    else if p_at_end {
        // the last player was already deleted, but the second last was not
        // we take the other player that was at the end and move them to the other player's spot
        //then we delete the second last player
        // if p1 was updated, then we know p2 was not   
        // if p2 was updated, then we know p1 was not
        if p1_updated {
            p2.player = second_last_member.player;
            p2.elo = second_last_member.elo;
            p2.timestamp = second_last_member.timestamp;

            world.erase_model(@second_last_member);
            world.write_model(@p2);
        }
        else if p2_updated {
            p1.player = second_last_member.player;
            p1.elo = second_last_member.elo;
            p1.timestamp = second_last_member.timestamp;

            world.erase_model(@second_last_member);
            world.write_model(@p1);

        }
        else {
            panic!("no player updated, but p_at_end is true");
        }
    }
    else if p_at_2end {
        // the last player was already deleted, but the second last was not
        // we take the other player that was at the end and move them to the other player's spot
        //then we delete the last player
        if p1_updated {
            p2.player = last_member.player;
            p2.elo = last_member.elo;
            p2.timestamp = last_member.timestamp;

            world.erase_model(@last_member);
            world.write_model(@p2);
        }
        else if p2_updated {
            p1.player = last_member.player;
            p1.elo = last_member.elo;
            p1.timestamp = last_member.timestamp;

            world.erase_model(@last_member);
            world.write_model(@p1);

        }
        else {
            panic!("no player updated, but p_at_2end is true");
        }
    }
    else {
        // neither player was at the end, se we just replace p1 with the last, and p2 with the second last
        p1.player = last_member.player;
        p1.elo = last_member.elo;
        p1.timestamp = last_member.timestamp;

        p2.player = second_last_member.player;
        p2.elo = second_last_member.elo;
        p2.timestamp = second_last_member.timestamp;

        world.erase_model(@last_member);
        world.erase_model(@second_last_member);
        world.write_model(@p1);
        world.write_model(@p2);
    }
    queue.length -= 2;
    world.write_model(@queue);

}