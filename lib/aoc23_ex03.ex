defmodule AdventOfCode23Ex03 do
  @type machine :: {data :: String, x :: integer, y :: integer}

  def load_lines(file_name) do
    {:ok, contents} = File.read(file_name)
    lines = contents |> String.split("\n", trim: true)
    lines
  end

  def parse_char(line, index_y, index, chars) do
    if index >= String.length(line) do
      Enum.reverse(chars)
    else
      cur = String.at(line, index)

      new_char =
        case {Integer.parse(cur), cur} do
          {:error, "."} -> {:dot, {index, index_y}, cur}
          {:error, _} -> {:symbol, {index, index_y}, cur}
          {_, _} -> {:digit, {index, index_y}, cur}
        end

      new_chars = [new_char | chars]
      parse_char(line, index_y, index + 1, new_chars)
    end
  end

  def fold_digits(digit, number) do
    {:digit, pos_d, str_d} = digit
    {:number, pos_n, str_n} = number

    new_pos_n =
      case pos_n do
        nil -> pos_d
        _ -> pos_n
      end

    new_str_n = str_n ++ str_d
    {:number, new_pos_n, new_str_n}
  end

  def mk_number(digit, number_part) do
    case {digit, number_part} do
      {{:digit, pos_d, str_d}, nil} ->
        {:number, pos_d, str_d}

      {{:digit, _, str_d}, {:number, pos_n, str_n}} ->
        {:number, pos_n, "#{str_n}#{str_d}"}
    end
  end

  def extract_tokens(items, number_part, numbers, symbols) do
    case {items, number_part} do
      {[], nil} ->
        {Enum.reverse(numbers), Enum.reverse(symbols)}

      {[], num} ->
        {Enum.reverse([num | numbers]), Enum.reverse(symbols)}

      {[{:digit, pos, str} | tail], num} ->
        digit = {:digit, pos, str}
        new_num = mk_number(digit, num)
        extract_tokens(tail, new_num, numbers, symbols)

      {[{:symbol, pos, str} | tail], num} ->
        symbol = {:symbol, pos, str}

        new_numbers =
          case num do
            nil ->
              numbers

            num ->
              [num | numbers]
          end

        extract_tokens(tail, nil, new_numbers, [symbol | symbols])

      {[_ | tail], nil} ->
        extract_tokens(tail, nil, numbers, symbols)

      {[_ | tail], num} ->
        extract_tokens(tail, nil, [num | numbers], symbols)
    end
  end

  def neighbor_symbols(tokens_arr, index) do
    prev_index = index - 1

    {_, prev_symbols} =
      if prev_index >= 0 do
        tokens_arr[prev_index]
      else
        {[], []}
      end

    len = Arrays.size(tokens_arr)
    next_index = index + 1

    {_, next_symbols} =
      if next_index < len do
        tokens_arr[next_index]
      else
        {[], []}
      end

    prev_symbols ++ next_symbols
  end

  def is_adjacent(symbol_x, min_x, max_x) do
    case symbol_x do
      s when s >= min_x and s <= max_x -> true
      _ -> false
    end
  end

  def try_mk_part(number, symbols) do
    {:number, {x, y}, str_value} = number
    str_idx_start = x
    str_idx_end = x + String.length(str_value)
    min_x = str_idx_start - 1
    max_x = str_idx_end

    is_part =
      Enum.any?(symbols, fn {:symbol, {symbol_x, _}, _} -> is_adjacent(symbol_x, min_x, max_x) end)

    case is_part do
      true -> {:part, {x, y}, str_value}
      false -> nil
    end
  end

  def mk_part_numbers(tokens_arr, index, line_tokens) do
    nb_symbols = neighbor_symbols(tokens_arr, index)
    {numbers, symbols} = line_tokens
    all_symbols = nb_symbols ++ symbols

    parts =
      Enum.map(numbers, fn n -> try_mk_part(n, all_symbols) end)
      |> Enum.filter(fn x -> x end)

    {parts, numbers, symbols}
  end

  def mk_part_numbers(tokens_arr) do
    new_line_tokens =
      Enum.with_index(tokens_arr)
      |> Enum.map(fn {line_tokens, index} -> mk_part_numbers(tokens_arr, index, line_tokens) end)

    new_line_tokens
  end

  def parse_line(line, index_y) do
    items = parse_char(line, index_y, 0, [])
    {numbers, symbols} = extract_tokens(items, nil, [], [])
    {numbers, symbols}
  end

  def collect_part_numbers(parts) do
    num_strings =
      Enum.map(parts, fn {:part, _, num_str} -> num_str end)

    numbers =
      Enum.map(num_strings, fn num_str ->
        {v, _} = Integer.parse(num_str)
        v
      end)

    numbers
  end

  def part1(filename) do
    lines = load_lines(filename)

    line_tokens =
      Enum.with_index(lines) |> Enum.map(fn {line, index} -> parse_line(line, index) end)

    tokens_arr = Arrays.new(line_tokens)
    items = mk_part_numbers(tokens_arr)

    part_numbers =
      Enum.map(items, fn {parts, _, _} -> collect_part_numbers(parts) end)
      |> List.flatten()

    sum = Enum.sum(part_numbers)
    sum
  end

  def example1 do
    part1("data/ex03_example.txt")
  end

  def part1 do
    part1("data/ex03_inputs.txt")
  end

  def is_star(symbol) do
    case symbol do
      {:symbol, _, "*"} -> true
      _ -> false
    end
  end

  def filter_stars(numbers, symbols) do
    stars = Enum.filter(symbols, fn s -> is_star(s) end)
    {numbers, stars}
  end

  def neighbor_numbers(tokens_arr, index) do
    prev_index = index - 1

    {prev_numbers, _} =
      if prev_index >= 0 do
        tokens_arr[prev_index]
      else
        {[], []}
      end

    len = Arrays.size(tokens_arr)
    next_index = index + 1

    {next_numbers, _} =
      if next_index < len do
        tokens_arr[next_index]
      else
        {[], []}
      end

    prev_numbers ++ next_numbers
  end

  def try_mk_gear(symbol, numbers) do
    {:symbol, {symbol_x, y}, _} = symbol

    adj_numbers =
      Enum.filter(numbers, fn {:number, {number_x, _}, str} ->
        is_adjacent(symbol_x, number_x - 1, number_x + String.length(str))
      end)

    case adj_numbers do
      [{:number, _, first} | [{:number, _, second}]] -> {:gear, {symbol_x, y}, {first, second}}
      _ -> nil
    end
  end

  def mk_gears(tokens_arr, index, line_tokens) do
    nb_numbers = neighbor_numbers(tokens_arr, index)
    {numbers, symbols} = line_tokens
    all_numbers = nb_numbers ++ numbers

    gears =
      Enum.map(symbols, fn n -> try_mk_gear(n, all_numbers) end)
      |> Enum.filter(fn x -> x end)

    {gears, numbers, symbols}
  end

  def mk_gears(tokens_arr) do
    new_line_tokens =
      Enum.with_index(tokens_arr)
      |> Enum.map(fn {line_tokens, index} -> mk_gears(tokens_arr, index, line_tokens) end)

    new_line_tokens
  end

  def gear_ratio(v1_str, v2_str) do
    v1 = String.to_integer(v1_str)
    v2 = String.to_integer(v2_str)
    v1 * v2
  end

  def part2(filename) do
    lines = load_lines(filename)

    line_tokens =
      Enum.with_index(lines) |> Enum.map(fn {line, index} -> parse_line(line, index) end)

    line_tokens_stars =
      Enum.map(line_tokens, fn {numbers, symbols} -> filter_stars(numbers, symbols) end)

    tokens_arr = Arrays.new(line_tokens_stars)
    items = mk_gears(tokens_arr)

    gears =
      Enum.map(items, fn {gears, _, _} -> gears end)
      |> List.flatten()

    gear_ratios =
      Enum.map(gears, fn {:gear, _, {v1, v2}} -> gear_ratio(v1, v2) end)

    sum = Enum.sum(gear_ratios)
    sum
  end

  def example2() do
    part2("data/ex03_example.txt")
  end

  def part2() do
    part2("data/ex03_inputs.txt")
  end
end
