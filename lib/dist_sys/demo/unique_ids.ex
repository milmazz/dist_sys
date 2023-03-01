defmodule DistSys.Demo.UniqueIds do
  @moduledoc """
  A globally-unique ID generation system

  This is the second challenge from the Gossip Glomers series.

  See: https://fly.io/dist-sys/2/
  """

  alias DistSys.Node

  @table :unique_ids

  def run do
    :ets.new(@table, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    Node.new(handlers: %{"generate" => &__MODULE__.generate/1})
  end

  # TODO: Calculate some confidence about this approach
  def generate(%{"body" => %{"type" => "generate"}, "src" => src, "dest" => dest} = msg) do
    counter = :ets.update_counter(@table, src, {2, 1}, {src, 0})
    scheduler_id = :erlang.system_info(:scheduler_id)

    Node.reply(msg, %{
      "type" => "generate_ok",
      "id" => "#{dest}-#{src}-#{scheduler_id}-#{counter}"
    })
  end
end
