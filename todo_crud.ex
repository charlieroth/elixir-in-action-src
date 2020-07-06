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
    # Update the entry's id value with the value stored in the auto_id field
    entry = Map.put(entry, :id, todo_list.auto_id)
    # Add it to the entries collection
    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    # Update the TodoList struct instance
    %TodoList{todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id + 1
    }
  end

  def entries(todo_list, date) do
    # When using Enum and Stream, each map element is treated in
    # the form of {key, value}
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list, entry_id) do
      :error ->
        todo_list
      
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    new_entries = Map.delete(todo_list, entry_id)
    %TodoList{todo_list | entries: new_entries}
  end
end

# TODO: Implement
defmodule TodoList.CsvImporter do
end
