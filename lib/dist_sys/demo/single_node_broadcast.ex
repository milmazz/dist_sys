defmodule DistSys.Demo.SingleNodeBroadcast do
  @moduledoc """
  A broadcast server

  This is the third challenge from the Gossip Glomers series.

  See: https://fly.io/dist-sys/3/
  """

  alias DistSys.Node

  @table :messages

  def run do
    :ets.new(@table, [
      :duplicate_bag,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    Node.start_link(
      handlers: %{
        "broadcast" => &__MODULE__.broadcast/1,
        "read" => &__MODULE__.read/1,
        "topology" => &__MODULE__.topology/1
      }
    )

    Node.loop()
  end

  def broadcast(%{"body" => %{"type" => "broadcast"} = body, "src" => src} = msg) do
    %{"message" => message} = body
    :ets.insert(@table, {src, message})
    Node.reply(msg, %{"type" => "broadcast_ok"})
  end

  def read(%{"body" => %{"type" => "read"} = _body} = msg) do
    messages = :ets.select(@table, [{{:"$1", :"$2"}, [], [:"$2"]}])

    Node.reply(msg, %{"type" => "read_ok", "messages" => messages})
  end

  def topology(%{"body" => %{"type" => "topology"} = _body} = msg) do
    Node.reply(msg, %{"type" => "topology_ok"})
  end
end
