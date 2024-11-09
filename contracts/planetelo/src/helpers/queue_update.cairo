use dojo::{WorldStorage};
use dojo::models::{Member, Queue};

fn update_queue(ref world: WorldStorage, p1: Member, p2: Member) {
    let mut queue: Queue = world.read_model((p1.game, p1.playlist));

    let mut new_member_ids: Array<u128> = Array::new();
    let queue_length = queue.members.len(); 

    let (last_index, last2_index) = (queue_length - 1, queue_length - 2);

    let mut end_updated: bool = false;
    let mut second_end_updated: bool = false;

    //if they are at the end, just delete
    if p1.index == last_index || p1.index == last2_index {
        world.erase_model(p1);
        if p1.index == last_index {
            p_at_end = true;
        }
        else {
            p_at_2end = true;
        }
    }
    if p2.index == queue_length - 1 || p2.index == queue_length -2 {
        world.erase_model(p2);
        if p2.index == last_index {
            p_at_end = true;
        }
        else {
            p_at_2end = true;
        }
    }

    let last_member: Member = world.read_model((p1.game, p1.playlist, last_index));
    let last2_member: Member = world.read_model((p2.game, p2.playlist, last2_index));

    let mut members = queue.members.clone();

    let mut p1_updated: bool = false;
    let mut p2_updated: bool = false;

    loop {
        match members.pop_front() {
            Some(member) => {

                if (member != p1.index && member != p2.index && !p1_at_end && !p2_at_end) {
                    //if both are not in the last two positions, move last 2 positions to their spots and delelete the last 2 positions
                    p1.player = last_member.player;
                    p1.elo = last_member.elo;
                    p1.timestamp = last_member.timestamp;

                    last_member.player = contract_address_const::<0x0>();
                    last_member.elo = 0;
                    last_member.timestamp = 0;

                    potential_index.player = second_last_player.player;
                    potential_index.elo = second_last_player.elo;
                    potential_index.timestamp = second_last_player.timestamp;

                    last2_member.player = contract_address_const::<0x0>();
                    last2_member.elo = 0;
                    last2_member.timestamp = 0;

                    world.erase_model(last_member);
                    world.erase_model(last2_member);
                    world.write_model(player_index);
                    world.write_model(potential_index);
                    
                }
                else if (member == p1.index) {
                        if (!end_updated && !p1_updated) {
                            let p1 = last_member;
                            end_updated = true;
                            p1_updated = true;
                            world.erase_model(last_member);
                            world.write_model(p1);
                        }
                        else if (!second_end_updated && !p1_updated) {
                            let p1 = last2_member;
                            second_end_updated = true;
                            p1_updated = true;
                            world.erase_model(last2_member);
                            world.write_model(p1);
                        }
                        else {
                            panic!("p1 not updated");
                        }
                }
                else if (member == p2.index) {
                    if (!end_updated && !p2_updated) {
                        let p2 = last_member;
                        end_updated = true;
                        p2_updated = true;
                        world.erase_model(last_member);
                        world.write_model(p2);
                    }
                    else if (!second_end_updated && !p2_updated) {
                        let p2 = last2_member;
                        second_end_updated = true;
                        p2_updated = true;
                        world.erase_model(last2_member);
                        world.write_model(p2);
                    }
                    else {
                        panic!("p2 not updated");
                    }
                }
                
                if (member != p1.index && member != p2.index) {
                    new_member_ids.append(member);
                }
            },
            None => {
                break;
            }
        }
    }



}