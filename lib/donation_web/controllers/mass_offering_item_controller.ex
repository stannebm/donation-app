defmodule DonationWeb.MassOfferingItemController do
  use DonationWeb, :controller

  alias Donation.MassOfferings
  alias Donation.MassOfferings.Offering

  action_fallback DonationWeb.FallbackController

  # def index(conn, _params) do
  #   mass_offering_items = MassOfferings.list_mass_offering_items()
  #   render(conn, "index.json", mass_offering_items: mass_offering_items)
  # end

  def index(conn, %{"mass_offering_id" => mass_offering_id}) do
    mass_offering = MassOfferings.get_mass_offering!(mass_offering_id)
    render(conn, "index.json", offerings: mass_offering.offerings)
  end

  # def create(conn, %{"mass_offering_item" => mass_offering_item_params}) do
  #   with {:ok, %MassOfferingItem{} = mass_offering_item} <- MassOfferings.create_mass_offering_item(mass_offering_item_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.mass_offering_item_path(conn, :show, mass_offering_item))
  #     |> render("show.json", mass_offering_item: mass_offering_item)
  #   end
  # end

  def create(conn, %{"mass_offering_id" => mass_offering_id, "offering" => offering_params}) do
    mass_offering = MassOfferings.get_mass_offering!(mass_offering_id)

    with {:ok, %Offering{} = mass_offering_item} <-
           MassOfferings.create_offering(mass_offering, offering_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.mass_offering_item_path(conn, :show, mass_offering_item))
      |> put_resp_header(
        "location",
        Routes.mass_offering_mass_offering_item_path(
          conn,
          :show,
          mass_offering_id,
          mass_offering_item
        )
      )
      |> render("show.json", mass_offering_item: mass_offering_item)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   mass_offering_item = MassOfferings.get_offering!(id)
  #   render(conn, "show.json", mass_offering_item: mass_offering_item)
  # end

  def update(conn, %{"id" => id, "offering" => offering_params}) do
    offering = MassOfferings.get_offering!(id)

    with {:ok, %Offering{} = offering} <- MassOfferings.update_offering(offering, offering_params) do
      render(conn, "show.json", offering: offering)
    end
  end

  def delete(conn, %{"id" => id}) do
    offering = MassOfferings.get_offering!(id)

    with {:ok, %Offering{}} <- MassOfferings.delete_offering(offering) do
      send_resp(conn, :no_content, "")
    end
  end
end
