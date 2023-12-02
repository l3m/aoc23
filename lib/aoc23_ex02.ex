defmodule AdventOfCode23Ex02 do
  @type cubes :: {red :: integer, green :: integer, blue :: integer}
  @type game :: {number :: integer, cubes :: cubes}

  def str_to_cube_count(cube_str) do
    [count_str, color] = String.split(String.trim(cube_str), " ", parts: 2)
    count = String.to_integer(count_str)
    {count, color}
  end

  def update_cubes(count, color, cubes) do
    case {color, cubes} do
      {"red", {red, green, blue}} when count > red -> {count, green, blue}
      {"green", {red, green, blue}} when count > green -> {red, count, blue}
      {"blue", {red, green, blue}} when count > blue -> {red, green, count}
      _ -> cubes
    end
  end

  def fold_cubes(line, cubes) do
    {count, color} = str_to_cube_count(line)
    update_cubes(count, color, cubes)
  end

  def cubes_str_to_cubes(cubes_str) do
    cube_lines = String.split(cubes_str, ";")
    cube_color_lists = Enum.map(cube_lines, fn v -> String.split(v, ",") end)
    cube_colors = Enum.concat(cube_color_lists)
    cube_colors_trimmed = Enum.map(cube_colors, fn v -> String.trim(v) end)

    cubes = List.foldl(cube_colors_trimmed, {0, 0, 0}, fn line, acc -> fold_cubes(line, acc) end)
    cubes
  end

  def str_to_game(line) do
    [game_str, cubes_str] = String.split(line, ":", parts: 2)
    number_str = String.slice(game_str, 5..String.length(game_str))
    number = String.to_integer(number_str)
    cubes = cubes_str_to_cubes(cubes_str)

    {number, cubes}
  end

  def possible_game(game, total_cubes) do
    case {game, total_cubes} do
      {{_, {sr, sg, sb}}, {tr, tg, tb}} when sr <= tr and sg <= tg and sb <= tb -> true
      _ -> false
    end
  end

  def load_games do
    {:ok, contents} = File.read("data/ex02_inputs.txt")
    lines = contents |> String.split("\n", trim: true)
    games = Enum.map(lines, fn line -> str_to_game(line) end)
    games
  end

  def ex02_1 do
    games = load_games()
    total_cubes = {12, 13, 14}
    possible_games = Enum.filter(games, fn g -> possible_game(g, total_cubes) end)
    possible_games_ids = Enum.map(possible_games, fn {game_id, _} -> game_id end)
    ids_sum = Enum.sum(possible_games_ids)
    ids_sum
  end

  def ex02_2 do
    games = load_games()
    powers_of_games = Enum.map(games, fn {_, {r, g, b}} -> r * g * b end)
    powers_sum = Enum.sum(powers_of_games)
    powers_sum
  end
end
