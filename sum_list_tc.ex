defmodule ListHelperTC do
  def sum(list) do
    do_sum(0, list)
  end

  # Handles empty list by returning the current sum
  defp do_sum(curr_sum, []) do
    curr_sum
  end

  # Handles non-empty list with tail recursion
  defp do_sum(curr_sum, [head | tail]) do
    do_sum(head + curr_sum, tail) # tail recursive call
  end
end
