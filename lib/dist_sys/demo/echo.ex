defmodule DistSys.Demo.Echo do
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
