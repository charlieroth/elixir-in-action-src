defmodule ProjectNameTest do
  use ExUnit.Case
  doctest ProjectName

  test "greets the world" do
    assert ProjectName.hello() == :world
  end
end
