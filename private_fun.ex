defmodule TestPrivate do
  # Import another module into your own
  import IO
  # Create an alias to a module with a different name
  alias IO, as: MyIO

  def double(a) do
    sum(a,a)
  end

  # Private function declaration
  defp sum(a, b) do
    a + b |> Integer.to_string |> puts
  end
end
