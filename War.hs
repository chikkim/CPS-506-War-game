module War where

import Data.Function(on)
import Data.List (sortBy, groupBy)

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}

{-- 
function deal takes a list of integers representing a deck of cards, 
shuffles the deck using the 'shuffle' fucntion, and plays a game of War
with teh shuffled deck using the 'play' fucntion. 
--}
deal :: [Int] -> [Int] 
deal cards =
    let (p1, p2) = shuffle cards 
        card = play p1 p2 
    in card

{-- 
fucntion 'shuffle' takes a list and returns a tuple containign two lists
representing shuffled decks. It uses a helper fucntion 'go; that takes an 
accumulator tuple and the reaming cards and adds each card to one of the
two lists in the accumulator based on which list is currently shorter.
--}

shuffle :: [a] -> ([a], [a])
shuffle list = go ([], []) list
  where
    go :: ([a], [a]) -> [a] -> ([a], [a])
    go acc [] = acc
    go (player1, player2) (c : cs)
      | length player1 > length player2 = go (player1, player2 ++ [c]) cs
      | otherwise = go (player1 ++ [c], player2) cs

{--
function, play, takes two lists of integers representing two decks of 
cards and simulates a game of War between the two players. It recursively 
plays rounds of the game until one player runs out of cards or until a war 
occurs. A war occurs when two cards of equal rank are played, and in this
case the function calls the helper function handleWar, which takes the 
current cards in play and the remaining cards in the players' decks and 
simulates a war.
--}

play :: [Int] -> [Int] -> [Int]
play [] [] = []
play [] card = card
play card [] = card
play (p1h : t1) (p2h : t2)
  | rank p1h > rank p2h = play (t1 ++ [p1h, p2h]) t2
  | rank p1h < rank p2h = play t1 (t2 ++ [p2h, p1h])
  | rank p1h == rank p2h = handleWar (p1h : t1) (p2h : t2)
  where
    handleWar t1 t2
      | null t1 && null t2 = sortBy (flip compare `on` rank) ([p1h, p2h] ++ t1 ++ t2)
      | null t1 = t2 ++ [p1h, p2h]
      | null t2 = t1 ++ [p2h, p1h]
      | otherwise = war (drop 1 t1) (drop 1 t2) (p1h : p2h : take 1 t1 ++ take 1 t2)

{-- 
The warGame function takes three arguments: two lists of integers 
representing the cards in each player's hand, and a list representing the 
cards that have been played and discarded.

The rank function takes an integer card and returns its rank, 
which is determined by its face value. In this implementation, all 
cards except the ace (which has a face value of 1) have the same rank 
as their face value. The ace has a rank of 14.

The warGame function uses recursion to simulate a game of War,
 a card game in which two players each play a card from their hand, 
 and the player with the higher-ranked card wins the round and adds both 
 cards to their pile. If the two cards have the same rank, a "war" is 
 declared, and additional cards are played face-down before another 
 card is played face-up to determine the winner.


--}

warGame :: [Int] -> [Int] -> [Int] -> [Int]
warGame [] [] list = sortBy (flip compare `on` rank) list
warGame [] winner list = winner ++ sortBy (flip compare `on` rank) list
warGame winner [] list = winner ++ sortBy (flip compare `on` rank) list
warGame (h1 : tail1) (h2 : tail2) list
  | rank h1 > rank h2 = play (t1 ++ sortBy (flip compare `on` rank) ([h1, h2] ++ list)) t2
  | rank h1 < rank h2 = play t1 (t2 ++ sortBy (flip compare `on` rank) ([h2, h1] ++ list))
  | rank h1 == rank h2 = case (length t1, length t2) of
    (0, 0) -> sortBy (flip compare `on` rank) (list ++ [h1, h2] ++ t1 ++ t2)
    (0, _) -> t2 ++ sortBy (flip compare `on` rank) ([h1, h2] ++ list)
    (_, 0) -> t1 ++ sortBy (flip compare `on` rank) ([h2, h1] ++ list)
    _ -> warGame (drop 1 t1) (drop 1 t2) (h1 : h2 : take 1 t1 ++ take 1 t2 ++ list)

rank :: Int -> Int
rank card = case card of
    1 -> 14
    _ -> card 
