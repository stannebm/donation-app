defmodule DonationWeb.MassOfferingController do
  use DonationWeb, :controller

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOffering

  use PhoenixSwagger

  action_fallback DonationWeb.FallbackController

  swagger_path :index do
    get "/api/mass_offerings"
    description "List of Mass Offerings"
    response 200, "Success"
  end

  def index(conn, _params) do
    mass_offerings = MassOfferings.list_mass_offerings()
    render(conn, "index.json", mass_offerings: mass_offerings)
  end

  # swagger_path :create do
  #   get "/api/mass_offerings"
  #   description "List of Mass Offerings"
  #   response 200, "Success"
  # end

  def create(conn, %{"mass_offering" => mass_offering_params}) do
    with {:ok, %MassOffering{} = mass_offering} <- MassOfferings.create_mass_offering(mass_offering_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mass_offering_path(conn, :show, mass_offering))
      |> render("show.json", mass_offering: mass_offering)
    end
  end

  swagger_path :show do
    get "/api/mass_offerings/{id}"
    description "Get a mass offering by ID and show mass offering items"
    parameter :id, :path, :integer, "Mass Offering ID", required: true
    response 200, "Success"
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

  # swagger_path :delete do
  #   delete "/api/mass_offerings/{id}"
  #   description "Delete a mass offering by ID"
  #   parameter :id, :path, :integer, "Mass Offering ID", required: true, example: 3
  #   response 203, "No Content - Deleted Successfully"
  # end

  def delete(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{}} <- MassOfferings.delete_mass_offering(mass_offering) do
      send_resp(conn, :no_content, "")
    end
  end
end
