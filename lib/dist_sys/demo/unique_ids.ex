defmodule DistSys.Demo.UniqueIds do
  @moduledoc """
  A globally-unique ID generation system

  This is the second challenge from the Gossip Glomers series.

  See: https://fly.io/dist-sys/2/
  """

  alias DistSys.Node

  def run do
    Node.start_link(handlers: %{"generate" => &__MODULE__.generate/1})
    Node.loop()
  end

  def generate(%{"body" => %{"type" => "generate"}} = msg) do
    Node.reply(msg, %{
      "type" => "generate_ok",
      "id" => [System.system_time(:nanosecond), System.unique_integer([:monotonic])]
    })
  end
end
