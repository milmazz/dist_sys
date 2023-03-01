# DistSys

A series of distributed systems challenges known as [Gossip Glomers][]

For `maelstrom`, the concept of nodes are a plain old binaries written in any
language. For Elixir, you can build an executable that can be invoked from the
command line with: `mix escript.build` or `mix escript.install`. Please read
the help for these Mix tasks with `mix help escript.build` or `mix help
escript.install` for more information.

## Demos

To run the demos you can do the following.

* `echo`

```console
./maelstrom test -w echo \
  --bin ~/dist_sys/dist_sys echo \
  --node-count 1 \
  --time-limit 10
```

* `unique_ids`

```console
./maelstrom test -w unique-ids \
  --bin ~/dist_sys/dist_sys unique_ids \
  --time-limit 30 \
  --rate 1000 \
  --node-count 3 \
  --availability total \
  --nemesis partition
```

* `broadcast`

```console
./maelstrom test -w broadcast \
  --bin ~/dist_sys/dist_sys broadcast \
  --node-count 1 \
  --time-limit 20 \
  --rate 10
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

[Gossip Glomers]: https://fly.io/dist-sys/
