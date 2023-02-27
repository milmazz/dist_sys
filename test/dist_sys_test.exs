defmodule DistSysTest do
  use ExUnit.Case
  doctest DistSys

  test "greets the world" do
    assert DistSys.hello() == :world
  end
end
