defmodule Todo.Server do
  use GenServer
  
  def start() do
    GenServer.start(__MODULE__, nil)
  end
  
  def add_entry(spid, new_entry) do
    GenServer.cast(spid, {:add_entry, new_entry})
  end

  def entries(spid, date) do
    GenServer.call(spid, {:entries, date})
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end
  
  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end
end
