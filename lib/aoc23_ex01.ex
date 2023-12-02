defmodule AdventOfCode23Ex01 do
  def try_int(v) do
    case Integer.parse(v) do
      {v, _} -> v
      :error -> nil
    end
  end

  def find_value(line) do
    gs = String.graphemes(line)
    value_l = Enum.find_value(gs, fn x -> try_int(x) end)
    gs_rev = Enum.reverse(gs)
    value_r = Enum.find_value(gs_rev, fn x -> try_int(x) end)
    10 * value_l + value_r
  end

  def load_lines do
    {:ok, contents} = File.read("data/ex01_inputs.txt")
    lines = contents |> String.split("\n", trim: true)
    lines
  end

  def ex01_1 do
    lines = load_lines()
    values = Enum.map(lines, fn x -> find_value(x) end)
    value = Enum.sum(values)
    value
  end

  def try_index_and_value(gs, index) do
    case index do
      nil -> nil
      _ -> {index, try_int(Enum.at(gs, index))}
    end
  end

  def find_digits(line) do
    gs = String.graphemes(line)
    index_l = Enum.find_index(gs, fn v -> try_int(v) end)
    gs_rev = Enum.reverse(gs)

    index_r =
      case Enum.find_index(gs_rev, fn v -> try_int(v) end) do
        nil -> nil
        index_r -> -1 + String.length(line) - index_r
      end

    left = try_index_and_value(gs, index_l)
    right = try_index_and_value(gs, index_r)
    {left, right}
  end

  def find_word3(line, index) do
    case String.slice(line, index..(index + 2)) do
      "one" -> {index, 1}
      "two" -> {index, 2}
      "six" -> {index, 6}
      _ -> nil
    end
  end

  def find_word4(line, index) do
    case String.slice(line, index..(index + 3)) do
      "four" -> {index, 4}
      "five" -> {index, 5}
      "nine" -> {index, 9}
      _ -> nil
    end
  end

  def find_word5(line, index) do
    case String.slice(line, index..(index + 4)) do
      "three" -> {index, 3}
      "seven" -> {index, 7}
      "eight" -> {index, 8}
      _ -> nil
    end
  end

  def find_word(line, index) do
    case find_word3(line, index) do
      nil ->
        case find_word4(line, index) do
          nil -> find_word5(line, index)
          v -> v
        end

      v ->
        v
    end
  end

  def find_words(line) do
    left = Enum.find_value(0..String.length(line), fn index -> find_word(line, index) end)
    right = Enum.find_value(String.length(line)..0, fn index -> find_word(line, index) end)
    {left, right}
  end

  def find_value2(line) do
    {digit_l, digit_r} = find_digits(line)
    {word_l, word_r} = find_words(line)

    left =
      case {digit_l, word_l} do
        {{index_d, value_d}, {index_w, _}} when index_d < index_w -> value_d
        {{_, value_d}, nil} -> value_d
        {_, {_, value_w}} -> value_w
        {nil, nil} -> 0
      end

    right =
      case {digit_r, word_r} do
        {{index_d, value_d}, {index_w, _}} when index_d > index_w -> value_d
        {{_, value_d}, nil} -> value_d
        {_, {_, value_w}} -> value_w
        {nil, nil} -> 0
      end

    value = 10 * left + right
    value
  end

  def ex01_2 do
    lines = load_lines()
    values = Enum.map(lines, fn x -> find_value2(x) end)
    value = Enum.sum(values)
    value
  end
end
