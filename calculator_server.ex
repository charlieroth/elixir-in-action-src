defmodule Calculator do
  def start() do
    spawn(fn -> loop(0) end) 
  end

  def add(spid, value), do: send(spid, {:add, value})
  def sub(spid, value), do: send(spid, {:sub, value})
  def mul(spid, value), do: send(spid, {:mul, value})
  def div(spid, value), do: send(spid, {:div, value})

  def value(spid) do
    send(spid, {:value, self()})
    receive do
      {:response, value} -> value
    end
  end

  defp loop(curr_value) do
    new_value = 
      receive do
        msg -> process_message(curr_value, msg)
      end
    loop(new_value)
  end

  defp process_message(curr_value, {:value, from}) do
    send(from, {:response, curr_value})
    curr_value
  end
  
  defp process_message(curr_value, {:add, value}) do
    curr_value + value
  end
  
  defp process_message(curr_value, {:sub, value}) do
    curr_value - value
  end

  defp process_message(curr_value, {:mul, value}) do 
    curr_value * value
  end

  defp process_message(curr_value, {:div, value}) do
    curr_value / value
  end
end
