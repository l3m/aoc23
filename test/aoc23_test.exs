defmodule Aoc23Test do
  use ExUnit.Case
  doctest Aoc23

  test "greets the world" do
    assert Aoc23.hello() == :world
  end

  test "ex01-a extract value" do
    input = "blah1x2argh"
    value = Aoc23.find_value(input)
    assert is_integer(value)
  end
end
