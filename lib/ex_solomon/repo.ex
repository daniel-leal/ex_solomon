defmodule ExSolomon.Repo do
  use Ecto.Repo,
    otp_app: :ex_solomon,
    adapter: Ecto.Adapters.Postgres
end
