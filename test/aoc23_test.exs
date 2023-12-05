defmodule AdventOfCode23Test do
  use ExUnit.Case
  doctest AdventOfCode23Ex01

  test "ex01_1 can extract value" do
    input = "blah1x2argh"
    value = AdventOfCode23Ex01.find_value(input)
    assert is_integer(value)
  end

  test "ex01_1 solution works" do
    value = AdventOfCode23Ex01.part1()
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
    value = AdventOfCode23Ex01.part2()
    assert 54719 = value
  end

  test "ex02_1 solution works" do
    value = AdventOfCode23Ex02.part1()
    assert 2331 = value
  end

  test "ex02_2 solution works" do
    value = AdventOfCode23Ex02.part2()
    assert 71585 = value
  end

  test "ex03_1 can determine parts" do
    number = {:number, {5, 8}, "1234"}
    bad_sym1 = {:symbol, {3, 7}, "*"}
    bad_sym2 = {:symbol, {3, 9}, "*"}
    bad_sym3 = {:symbol, {10, 7}, "*"}
    bad_sym4 = {:symbol, {10, 9}, "*"}
    bad1 = AdventOfCode23Ex03.try_mk_part(number, [bad_sym1, bad_sym2, bad_sym3, bad_sym4])
    ExUnit.Assertions.refute bad1
    good_sym1 = {:symbol, {4, 7}, "*"}
    good1 = AdventOfCode23Ex03.try_mk_part(number, [good_sym1])
    assert good1
    good_sym2 = {:symbol, {9, 7}, "*"}
    good2 = AdventOfCode23Ex03.try_mk_part(number, [good_sym2])
    assert good2
  end

  test "ex03_1 example works" do
    value = AdventOfCode23Ex03.example1()
    assert 4361 = value
  end

  test "ex03_1 solution works" do
    value = AdventOfCode23Ex03.part1()
    assert 520135 = value
  end

  test "ex03_2 example works" do
    value = AdventOfCode23Ex03.example2()
    assert 467835 = value
  end

  test "ex03_2 solution works" do
    value = AdventOfCode23Ex03.part2()
    assert 72514855 = value
  end

  test "ex04_1 example works" do
    value = AdventOfCode23Ex04.example1()
    assert 13 = value
  end

  test "ex04_1 solution works" do
    value = AdventOfCode23Ex04.part1()
    assert 26914 = value
  end

  test "ex04_2 solution works" do
    value = AdventOfCode23Ex04.part2()
    assert 13080971 = value
  end

end
