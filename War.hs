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

deal :: [Int] -> [Int] 
deal cards =
    let (p1, p2) = shuffle cards 
        card = play p1 p2 
    in card

shuffle :: [a] -> ([a], [a])
shuffle list = go ([], []) list
  where
    go :: ([a], [a]) -> [a] -> ([a], [a])
    go acc [] = acc
    go (player1, player2) (c : cs)
      | length player1 > length player2 = go (player1, player2 ++ [c]) cs
      | otherwise = go (player1 ++ [c], player2) cs


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

war :: [Int] -> [Int] -> [Int] -> [Int]
war [] [] list = sortBy (flip compare `on` rank) list 
war [] winner list = winner ++ sortBy (flip compare `on` rank) list
war winner [] list = winner ++ sortBy (flip compare `on` rank) list
war (head1 : tail1) (head2 : tail2) list
  | rank head1 > rank head2 = play (tail1 ++ sortBy (flip compare `on` rank) ([head1, head2] ++ list)) tail2
  | rank head1 < rank head2 = play tail1 (tail2 ++ sortBy (flip compare `on` rank) ([head2, head1] ++ list))
  | rank head1 == rank head2 = case (length tail1, length tail2) of
    (0, 0) -> sortBy (flip compare `on` rank) (list ++ [head1, head2] ++ tail1 ++ tail2)
    (0, _) -> tail2 ++ sortBy (flip compare `on` rank) ([head1, head2] ++ list)
    (_, 0) -> tail1 ++ sortBy (flip compare `on` rank) ([head2, head1] ++ list)
    _ -> war (drop 1 tail1) (drop 1 tail2) (head1 : head2 : take 1 tail1 ++ take 1 tail2 ++ list)

rank :: Int -> Int
rank card = case card of
    1 -> 14
    _ -> card 
