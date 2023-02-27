defmodule DistSys.Demo.Echo do
  @moduledoc """
  A simple echo server

  This is the first challenge from the Gossip Glomers series.

  See: https://fly.io/dist-sys/1/
  """

  alias DistSys.Node

  def run do
    Node.start_link(handlers: %{"echo" => &__MODULE__.handle_echo/1})
    Node.loop()
  end

  def handle_echo(%{"body" => %{"type" => "echo"} = body} = msg) do
    %{"echo" => echo} = body

    Node.reply(msg, %{"type" => "echo_ok", "echo" => echo})
  end
end
