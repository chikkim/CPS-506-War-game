defmodule War do
import Enum
import compare_war_cards, only: [compare_war_cards: 3]
import compare_war_cards, only: [play: 4]
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add 
    as many additional helper functions as you want. 

    The tests for the deal function can be found in test/war_test.exs. 
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory 
    (the one containing mix.exs)
  """

  def deal(shuf) do
       n = div(length(shuf), 2)
	{hand1, hand2} = Enum.split(shuf |> Enum.shuffle(), n)
	merge(hand1 |> Enum.sort(), hand2 |> Enum.sort())
  end

@doc """
  Play a game of War and return the winning player or :tie if it is a tie.
  """
  def play(hand1, hand2) do
    case {hand1, hand2} do
      {[], _} -> :player2
      {_, []} -> :player1
      {h1, h2} ->
        {c1, rest1} = Enum.split(h1, 1)
        {c2, rest2} = Enum.split(h2, 1)

        case compare_cards(c1, c2) do
          :greater -> play(rest1 ++ [c1, c2], rest2)
          :less -> play(rest1, rest2 ++ [c2, c1])
          :equal -> play_war(rest1, rest2, [c1, c2])
        end
    end
  end

def play_war(hand1, hand2, winnings, count \\ 0) do
  case {Enum.split(hand1, 4), Enum.split(hand2, 4)} do
    {{[], _}, {_, _}} -> :player2
    {{_, _}, {[], _}} -> :player1
    {{[], _}, {[], _}} -> :tie
    {{cards1, rest1}, {cards2, rest2}} ->
      compare_war_cards(cards1, cards2, winnings, rest1, rest2, count)
  end
end

def compare_war_cards(cards1, cards2, winnings, rest1, rest2, count) do
  {last1, rest1_2} = Enum.split(cards1, 1)
  {last2, rest2_2} = Enum.split(cards2, 1)

  case compare_cards(last1, last2) do
    :greater -> 
       play(rest1 ++ winnings ++ cards1 ++ cards2, rest2, winnings ++ [last1, last2], 0)
    :less -> 
       play(rest1, rest2 ++ winnings ++ cards2 ++ cards1, winnings ++ [last2, last1], 0)
    :equal ->
      case {Enum.split(rest1_2, 4), Enum.split(rest2_2, 4)} do
        {{[], _}, {[], _}} -> :tie
        {{_, _}, {[], _}} ->
            play(rest1_2 ++ winnings ++ cards1 ++ cards2, rest2, winnings ++ [last1, last2], 0)
        {{[], _}, {_, _}} -> 
             play(rest1, rest2_2 ++ winnings ++ cards2 ++ cards1, winnings ++ [last2, last1], 0)
        {{cards1_2, rest1_3}, {cards2_2, rest2_3}} ->
          if count > 100 do
	     :tie
          else
          compare_war_cards(cards1_2, cards2_2, winnings ++ [last1, last2], rest1_3, rest2_3, count + 1)
      end
  end
end 
end
  def compare_cards(card1, card2) do
    if card1 > card2 do
      :greater
    else if card1 < card2 do
      :less
    else
      :equal
    end
  end
end
  def merge(hand1, hand2) do
    case {hand1, hand2} do
      {[], _} -> hand2
      {_, []} -> hand1
      {[card1 | rest1], [card2 | rest2]} ->
        case compare_cards(card1, card2) do
        :greater ->
          [card1, card2] ++ merge(rest1, rest2)
        :less ->
          [card2, card1] ++ merge(rest1, rest2)
        :equal ->
          [card1, card2] ++ merge(rest1, rest2)
      end
  end
end
end
