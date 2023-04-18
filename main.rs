#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.
    
    Test your code by running 'cargo test' from the war_rs directory.
*/

use std::collections::VecDeque;
/* deal fucntion takes a reference array of 52 values and returns new array of the same size
 * with the same values. 
 */
 
fn deal(shuf: &[u8; 52]) -> [u8; 52] {
    let mut deck = [0; 52];
    deck.copy_from_slice(shuf);
    deck
}
/* Shuffle fucntion takes mutable reference to an array of any type and shuffles its elements
 * randomly.
 */
 
fn shuffle<T>(deck: &mut [T]) {
    use rand::Rng;

    let mut rng = rand::thread_rng();

    for i in (1..deck.len()).rev() {
        let j = rng.gen_range(0..=i);
        deck.swap(i, j);
    }
}
/* defines a new struct with 3 fields: a winner field that holds a 'u8' value, and 2 'Vec<u8>' 
 * fields that hold the hands of player 1 and player 2.
 */
 
struct GameResult {
    winner: u8,
    player1_hand: Vec<u8>,
    player2_hand: Vec<u8>,
}

/* THe war_game fucntion defines the main logic of the game
 */
 
fn war_game() -> &'static str {
    let shuf = [
        1, 14, 27, 40, 2, 15, 28, 41, 3, 16, 29, 42, 4, 17, 30, 43,
        5, 18, 31, 44, 6, 19, 32, 45, 7, 20, 33, 46, 8, 21, 34, 47,
        9, 22, 35, 48, 10, 23, 36, 49, 11, 24, 37, 50, 12, 25, 38, 51,
        13, 26, 39, 52
    ];
    let deck = deal(&shuf);
    let mut player1: VecDeque<u8> = VecDeque::new();
    let mut player2: VecDeque<u8> = VecDeque::new();
    for i in 0..26 {
        player1.push_back(deck[i]);
        player2.push_back(deck[i + 26]);
    }
    while !player1.is_empty() && !player2.is_empty() {
        let card1 = player1.pop_front().unwrap();
        let card2 = player2.pop_front().unwrap();
        println!("Player 1 played card {}", card1);
        println!("Player 2 played card {}", card2);
        if card1 > card2 {
            println!("Player 1 wins the round!");
            player1.push_back(card1);
            player1.push_back(card2);
        } else if card2 > card1 {
            println!("Player 2 wins the round!");
            player2.push_back(card2);
            player2.push_back(card1);
        } else {
            println!("WAR!");
            if player1.len() < 4 || player2.len() < 4 {
                return "Game over, not enough cards for war!";
            }
            let mut war_cards: Vec<u8> = vec![card1, card2];
            for _ in 0..3 {
                war_cards.push(player1.pop_front().unwrap());
                war_cards.push(player2.pop_front().unwrap());
            }
            let war_card1 = player1.pop_front().unwrap();
            let war_card2 = player2.pop_front().unwrap();
            war_cards.push(war_card1);
            war_cards.push(war_card2);
            if war_card1 > war_card2 {
                println!("Player 1 wins the war!");
                for card in war_cards {
                    player1.push_back(card);
                }
            } else if war_card2 > war_card1 {
                println!("Player 2 wins the war!");
                for card in war_cards {
                    player2.push_back(card);
                }
            } else {
                println!("Another WAR!");
                return war_game();
            }
        }
        println!("Player 1 has {} cards, player 2 has {} cards", player1.len(), player2.len());
    }
    if player1.is_empty() {
        "Player 2 wins the game!"
    } else {
        "Player 1 wins the game!"
    }
}
/* Prints the result of the game
 */
fn main() {
    println!("{}", war_game());
}

#[cfg(test)]
#[path = "tests.rs"]
mod tests;

