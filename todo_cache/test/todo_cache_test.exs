defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    char_pid = Todo.Cache.server_process(cache, "char")
    assert char_pid != Todo.Cache.server_process(cache, "mir")
    assert char_pid == Todo.Cache.server_process(cache, "char")
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()
    mir = Todo.Cache.server_process(cache, "mir")
    Todo.Server.add_entry(mir, %{date: ~D[2020-01-01], title: "Todo 1"})
    entries = Todo.Server.entries(mir, ~D[2020-01-01])
    assert [%{date: ~D[2020-01-01], title: "Todo 1"}] = entries
  end
end
