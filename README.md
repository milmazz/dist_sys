# DistSys

A series of distributed systems challenges known as [Gossip Glomers][]

## Demos

To run the demos you can do the following.

* `echo`

```console
./maelstrom test -w echo --bin ~/dist_sys/dist_sys echo --node-count 1 --time-limit 10
```

* `unique_ids`

```console
./maelstrom test -w unique-ids --bin ~/dist_sys/dist_sys unique_ids --time-limit 30 --rate 1000 --node-count 3 --availability total --nemesis partition
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/dist_sys>.

[Gossip Glomers]: https://fly.io/dist-sys/
