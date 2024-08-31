defmodule Fileonchain.Repo do
  use Ecto.Repo,
    otp_app: :fileonchain,
    adapter: Ecto.Adapters.Postgres
end
