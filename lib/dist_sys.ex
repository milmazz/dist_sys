defmodule DistSys do
  @moduledoc """
  A series of distributed systems challenges known as Gossip Glomers 

  See https://fly.io/dist-sys/ for more information about the challenges.

  The entry point of this application is `DistSys.CLI`, there we will map the
  final module that implements the given workload via first argument by doing:

  ```console
  ~/dist_sys/dist_sys echo
  ```

  The workload implementation can be found under the `lib/dist_sys/demo` directory.

  Finally, this app includes a simple abstraction about the concept of a node
  with `DistSys.Node`, this module avoids some boilerplate while developing
  the workload implementations.
  """
end
