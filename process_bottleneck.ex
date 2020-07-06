defmodule Server do
  def start do
    spawn(fn -> loop() end)
  end

  def send_msg(spid, msg) do
    send(spid, {self(), msg})

    receive do
      {:response, response} -> response
    end
  end

  defp loop do
    receive do
      {from, msg} ->
        Process.sleep(1000)
        send(from, {:response, msg})
    end
  end
end
