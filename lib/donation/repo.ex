defmodule Donation.Repo do
  use Ecto.Repo,
    otp_app: :donation,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 50
end
