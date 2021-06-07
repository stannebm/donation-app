defmodule DonationWeb.ReportController do
  use DonationWeb, :controller

  alias Donation.Admins
  # alias Donation.Admins.Receipt

  action_fallback DonationWeb.FallbackController

  def index(conn, params) do
    receipts = Admins.search_receipts(params)
    render(conn, "index.html", receipts: receipts )
  end

end
