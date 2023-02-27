# DistSys

**TODO: Add description**

## Demos

To run the demos you can do the following.

* `echo` - `/maelstrom test -w echo --bin ~/dist_sys/dist_sys echo --node-count 1 --time-limit 10`
* `unique_ids` - `./maelstrom test -w unique-ids --bin ~/dist_sys/dist_sys unique_ids --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dist_sys` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dist_sys, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/dist_sys>.

