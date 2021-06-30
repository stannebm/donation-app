defmodule DonationWeb.WebFormApiController do
  use DonationWeb, :controller
  alias Donation.WebForms

  action_fallback(DonationWeb.FallbackController)

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

  # def fpx(conn, %{
  #       "reference_no" => ref,
  #       "txn_info" => %{"status" => status, "info" => info}
  #     }) do
  #   old = Contribution.get_offering_by_reference_no(ref)

  #   with {:ok, %Offering{} = o} <-
  #          Contribution.update_with_txn_info(old, :fpx, status == "OK", info) do
  #     render(conn, "show.json", offering: o)
  #   end
  # end

  # def cybersource(conn, %{
  #       "reference_no" => ref,
  #       "txn_info" => %{"status" => status, "info" => info}
  #     }) do
  #   old = Contribution.get_offering_by_reference_no(ref)

  #   with {:ok, %Offering{} = o} <-
  #          Contribution.update_with_txn_info(old, :cybersource, status == "OK", info) do
  #     render(conn, "show.json", offering: o)
  #   end
  # end
end
