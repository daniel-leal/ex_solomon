defmodule TimexBehaviour do
  @callback now() :: DateTime.t()
end

Mox.defmock(TimexMock, for: TimexBehaviour)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ExSolomon.Repo, :manual)
