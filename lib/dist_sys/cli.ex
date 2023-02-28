defmodule DistSys.CLI do
  @demos %{
    "echo" => DistSys.Demo.Echo,
    "unique_ids" => DistSys.Demo.UniqueIds,
    "broadcast" => DistSys.Demo.SingleNodeBroadcast
  }
  @demo_keys Map.keys(@demos)

  def main(args \\ []) do
    case OptionParser.parse(args, strict: []) do
      {[], [demo], []} when demo in @demo_keys ->
        Map.fetch!(@demos, demo).run()

      _ ->
        :error
    end
  end
end
