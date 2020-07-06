defmodule TodoServer do
  def start() do
    spawn(fn ->
      loop(TodoList.new())
    end)
  end
  
  def add_entry(spid, new_entry) do
    send(spid, {:add_entry, new_entry})
  end

  def entries(spid, date) do
    send(spid, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        msg -> process_msg(todo_list, msg)
      end
    loop(new_todo_list)
  end

  defp process_msg(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end
  
  defp process_msg(todo_list, {:update_entry, entry}) do
    TodoList.update_entry(todo_list, entry)
  end
  
  defp process_msg(todo_list, {:delete_entry, entry}) do
    TodoList.delete_entry(todo_list, entry)
  end
  
  defp process_msg(todo_list, {:entries, from, date}) do
    # Sends response to caller
    send(from, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list # state remains unchanged
  end

  defp process_msg(todo_list, _), do: todo_list
end

# https://elixir-lang.org/getting-started/structs.html#accessing-and-updating-structs
defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(todo_list, entry_id, updater_fn) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry} ->
        new_entry = updater_fn.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    new_entries = Map.delete(todo_list, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end
end
