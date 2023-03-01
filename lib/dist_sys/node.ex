defmodule DistSys.Node do
  @moduledoc """
  Simple abstraction of the Node server
  """

  use Agent

  @typedoc """
  Server state that we will track

  * `node_id` - the local node ID
  * `node_ids` - all the nodes in the cluster
  * `next_msg_id` - the next message id we will emit
  * `handlers` - list of hanlders supported by this server
  """
  @type t :: %__MODULE__{
          node_id: String.t(),
          node_ids: [String.t()],
          next_msg_id: non_neg_integer(),
          handlers: map()
        }

  defstruct [
    :node_id,
    node_ids: [],
    next_msg_id: 0,
    handlers: %{}
  ]

  ## Client API
  @doc """
  Starts a new node
  """
  def new(opts) do
    start_link(opts)
    loop()
  end

  def start_link(opts) do
    custom_handlers = Keyword.fetch!(opts, :handlers)

    Agent.start_link(fn -> %{%__MODULE__{} | handlers: custom_handlers} end, name: __MODULE__)
  end

  @doc """
  Retrieves the node ID
  """
  def node_id, do: Agent.get(__MODULE__, & &1.node_id)

  @doc """
  Sets the given node ID

  This is usually done after the `init` message type
  """
  def node_id(node_id), do: Agent.update(__MODULE__, &%{&1 | node_id: node_id})

  @doc """
  Retrieves the IDs of the nodes in the cluster
  """
  def node_ids, do: Agent.get(__MODULE__, & &1.node_ids)

  @doc """
  Set the list of node IDs in the cluster
  """
  def node_ids(node_ids), do: Agent.update(__MODULE__, &%{&1 | node_ids: node_ids})

  @doc """
  Retrieves the next message id

  This counter is usually needed when we reply a message
  """
  def next_msg_id,
    do:
      Agent.get_and_update(__MODULE__, &{&1.next_msg_id, %{&1 | next_msg_id: &1.next_msg_id + 1}})

  @doc """
  Retrieves the list of handlers for this node
  """
  def handlers, do: Agent.get(__MODULE__, & &1.handlers)

  @doc """
  Sends the given body to `dest` 
  """
  @spec dispatch(String.t(), term()) :: :ok
  def dispatch(dest, body) do
    node_id = node_id()
    msg = %{"src" => node_id, "dest" => dest, "body" => body}
    IO.warn("Sending #{inspect(msg)}")
    IO.write(Jason.encode!(msg))
    IO.write("\n")
  end

  @doc """
  Reply a request
  """
  def reply(req, body) do
    IO.warn("Received req: #{inspect(req)}, body: #{inspect(body)}")

    if msg_id = get_in(req, ["body", "msg_id"]) do
      body = Map.merge(body, %{"in_reply_to" => msg_id, "msg_id" => next_msg_id()})

      dispatch(req["src"], body)
    else
      raise "can't reply to request without message id: "
    end
  end

  ## Helpers
  defp loop() do
    msg = IO.binread(:stdio, :line)
    IO.warn("Read: #{inspect(msg)}")

    msg = Jason.decode!(msg)
    msg_type = get_in(msg, ["body", "type"])
    handlers = handlers()

    cond do
      msg_type == "init" ->
        prepare(msg)

      Map.has_key?(handlers, msg_type) ->
        handler = Map.get(handlers, msg_type)
        handler.(msg)

      true ->
        :todo_error
    end

    loop()
  end

  defp prepare(%{"body" => %{"type" => "init"} = body} = msg) do
    %{"node_id" => node_id, "node_ids" => node_ids} = body

    node_id(node_id)
    node_ids(node_ids)

    IO.warn("Node #{node_id} initialized")
    reply(msg, %{"type" => "init_ok"})
  end
end
