defmodule Donation.Repo do
  use Ecto.Repo,
    otp_app: :donation,
    adapter: Ecto.Adapters.Postgres
end
