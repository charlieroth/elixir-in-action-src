defmodule Todo.Database do
  use GenServer
  alias Todo.DatabaseWorker

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Obtain a worker's pid and forward to DatabaseWorker.store/3
  """
  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end
  
  @doc """
  Obtain a worker's pid and forward to DatabaseWorker.get/2
  """
  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end
  
  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key}) 
  end

  @doc """
  Creates directory to store data in
  """
  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end
  
  defp start_workers() do
    # Spawns three workers for the Database to delgate worker to
    for index <- 1..3, into: %{} do
      {:ok, pid} = DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end
  
  @doc """
  :choose_worker should always return the same worker for the same key
  Compute the key's numerical hash and normalixe it to fall in the range [0,2]
  """
  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end
end
