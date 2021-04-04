defmodule DonationWeb.MassOfferingController do
  use DonationWeb, :controller

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOffering

  action_fallback DonationWeb.FallbackController

  def index(conn, _params) do
    mass_offerings = MassOfferings.list_mass_offerings()
    render(conn, "index.json", mass_offerings: mass_offerings)
  end

  def create(conn, %{"mass_offering" => mass_offering_params}) do
    with {:ok, %MassOffering{} = mass_offering} <- MassOfferings.create_mass_offering(mass_offering_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mass_offering_path(conn, :show, mass_offering))
      |> render("show.json", mass_offering: mass_offering)
    end
  end

  def show(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)
    render(conn, "show.json", mass_offering: mass_offering)
  end

  def update(conn, %{"id" => id, "mass_offering" => mass_offering_params}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{} = mass_offering} <- MassOfferings.update_mass_offering(mass_offering, mass_offering_params) do
      render(conn, "show.json", mass_offering: mass_offering)
    end
  end

  def delete(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{}} <- MassOfferings.delete_mass_offering(mass_offering) do
      send_resp(conn, :no_content, "")
    end
  end
end
