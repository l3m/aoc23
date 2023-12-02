defmodule AdventOfCode23Test do
  use ExUnit.Case
  doctest AdventOfCode23Ex01

  test "ex01_1 can extract value" do
    input = "blah1x2argh"
    value = AdventOfCode23Ex01.find_value(input)
    assert is_integer(value)
  end

  test "ex01_1 solution works" do
    value = AdventOfCode23Ex01.ex01_1()
    assert 55971 = value
  end

  test "ex01_1 can find number word" do
    value = AdventOfCode23Ex01.find_word("three", 0)
    assert {0, 3} = value

    value2 = AdventOfCode23Ex01.find_word("three43421341three", 0)
    assert {0, 3} = value2

    value3 = AdventOfCode23Ex01.find_word("123five", 3)
    assert {3, 5} = value3
  end

  test "ex02_1 can parse game line" do
    value =
      AdventOfCode23Ex02.str_to_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")

    assert {1, {4, 2, 6}} = value
  end

  test "ex01_2 solution works" do
    value = AdventOfCode23Ex01.ex01_2()
    assert 54719 = value
  end

  test "ex02_1 solution works" do
    value = AdventOfCode23Ex02.ex02_1()
    assert 2331 = value
  end

  test "ex02_2 solution works" do
    value = AdventOfCode23Ex02.ex02_2()
    assert 71585 = value
  end
end
