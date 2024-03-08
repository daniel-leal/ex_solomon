defmodule ExSolomon.Repo do
  use Ecto.Repo,
    otp_app: :ex_solomon,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
