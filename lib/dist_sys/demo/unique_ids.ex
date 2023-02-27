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

  # NOTES
  #
  # * `System.unique_integer/1` will not work because we run multiple nodes and
  # it will generate duplicate numbers. Unless we split that integer per client
  # (`c1`, `c2`, etc.).
  #
  # * If we consider to split the counters per client, we can use `ETS` too, by something like:
  #
  # ```
  # :ets.new(@table, [:set, :named_table, :public, read_concurrency: true, write_concurrency: true])
  # counter = :ets.update_counter(@table, src, {2, 1}, {src, 0})
  # ```
  #
  # * another option that seems to satisfy `maelstrom` is returning:
  # `[System.system_time(:nanosecond), System.unique_integer([:monotonic])]`
  #
  # TODO: Revisit this because seems like cheating.
  def generate(%{"body" => %{"type" => "generate"}, "src" => src} = msg) do
    Node.reply(msg, %{
      "type" => "generate_ok",
      "id" => "#{src}-#{inspect(System.system_time(:nanosecond))}"
    })
  end
end
