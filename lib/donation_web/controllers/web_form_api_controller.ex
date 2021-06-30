defmodule DonationWeb.WebFormApiController do
  use DonationWeb, :controller
  alias Donation.WebForms

  def donation_form(conn, %{"donation" => params}) do
    with {:ok, created} <-
           WebForms.save_donation_form(params) do
      IO.puts("Donation Form saved:")
      IO.inspect(created)

      conn
      |> put_status(:created)
      |> text("OK")
    end
  end

  def mass_offering_form(conn, %{"mass_offering" => params}) do
    with {:ok, created} <-
           WebForms.save_mass_offering_form(params) do
      IO.puts("Mass Offering Form saved:")
      IO.inspect(created)

      conn
      |> put_status(:created)
      |> text("OK")
    end
  end
end
