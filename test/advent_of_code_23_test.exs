defmodule AdventOfCode23Test do
  use ExUnit.Case
  doctest AdventOfCode23Ex01

  test "ex01_1 can extract value" do
    input = "blah1x2argh"
    value = AdventOfCode23Ex01.find_value(input)
    assert is_integer(value)
  end

  test "ex01_1 can get value" do
    value = AdventOfCode23Ex01.ex01_1()
    assert is_integer(value)
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

  test "ex01_2 can get value" do
    value = AdventOfCode23Ex01.ex01_2()
    assert is_integer(value)
    assert 54719 = value
  end

end
