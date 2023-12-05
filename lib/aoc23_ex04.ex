defmodule AdventOfCode23Ex04 do
  def load_lines(file_name) do
    {:ok, contents} = File.read(file_name)
    lines = contents |> String.split("\n", trim: true)
    lines
  end

  def num_str_to_int_map_set(nums) do
    num_strings = nums |> String.split(" ", trim: true)
    nums = Enum.map(num_strings, fn n -> String.to_integer(n) end)
    MapSet.new(nums)
  end

  def parse_line(line) do
    regex = ~r/^Card\s{1,3}(?<card>\d*):(?<win>(\s{1,2}\d{1,2})*)\s\|(?<num>(\s{1,2}\d{1,2})*)$/
    matches = Regex.named_captures(regex, line)
    {:ok, card_num_str} = Map.fetch(matches, "card")
    card_num = String.to_integer(card_num_str)
    {:ok, wins_str} = Map.fetch(matches, "win")
    wins = num_str_to_int_map_set(wins_str)
    {:ok, nums_str} = Map.fetch(matches, "num")
    nums = num_str_to_int_map_set(nums_str)
    matching_numbers = MapSet.intersection(wins, nums)
    match_count = MapSet.size(matching_numbers)
    card = {:card, card_num, match_count}
    card
  end

  def card_value(card) do
    {:card, _, match_count} = card

    if match_count > 1 do
      v = :math.pow(2, match_count - 1)
      trunc(v)
    else
      match_count
    end
  end

  def part1(file_name) do
    lines = load_lines(file_name)
    cards = Enum.map(lines, fn line -> parse_line(line) end)
    values = Enum.map(cards, fn card -> card_value(card) end)
    total_value = Enum.sum(values)
    total_value
  end

  def example1 do
    part1("data/ex04_example.txt")
  end

  def part1 do
    part1("data/ex04_inputs.txt")
  end

  def collect(add_card_map, todo_cards, total_cards) do
    case todo_cards do
      [] -> total_cards
      [{:card, card_num, match_count}|tail] ->
        add_total =
          if match_count > 0 do
            copy_indices = Enum.to_list(card_num + 1..card_num + match_count)
            add_cards =
              List.foldl(copy_indices, 0, fn card_num, acc ->
                add = Map.get(add_card_map, card_num)
                acc + add
              end)
            add_cards
          else
            0
        end
        new_total = total_cards + 1 + add_total
        new_map = Map.put_new(add_card_map, card_num, 1 + add_total)
        collect(new_map, tail, new_total)
    end
  end

  def part2(file_name) do
    lines = load_lines(file_name)
    cards = Enum.map(lines, fn line -> parse_line(line) end)
    total_cards = collect(Map.new(), Enum.reverse(cards), 0)
    total_cards
  end

  def part2 do
    part2("data/ex04_inputs.txt")
  end
end
