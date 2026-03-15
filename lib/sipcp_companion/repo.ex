defmodule SipcpCompanion.Repo do
  use Ecto.Repo,
    otp_app: :sipcp_companion,
    adapter: Ecto.Adapters.Postgres
end
