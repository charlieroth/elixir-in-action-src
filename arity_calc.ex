defmodule Calculator do
  def sum(a) do
    # a lower-arity function is imple
    sum_def(a, 0)
  end

  # Defining a default value for the argument b
  def sum_def(a, b \\ 0) do
    a + b
  end

  def max_cond(a, b) do
    cond do
      a >= b -> a
      true -> b
    end
  end

  def max_case(a, b) do
    case a >= b do
      true -> a
      false -> b
    end
  end
end
