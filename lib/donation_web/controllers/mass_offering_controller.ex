defmodule DonationWeb.MassOfferingController do
  use DonationWeb, :controller
  use PhoenixSwagger

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOffering

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

  swagger_path :show do
    get "/api/mass_offerings/{id}"
    description "Get a mass offering by ID. Following the result of offerings."
    parameter :id, :path, :integer, "Mass Offering [ID]", required: true
    response 200, "Success"
    response 404, "Not found"
  end

  def show(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)
    render(conn, "show.json", mass_offering: mass_offering)
  end

  swagger_path :create do
    post "/api/mass_offerings"
    description "Create new Mass Offering"
    parameters do
      mass_offering :body, Schema.ref(:Mass_Offering), "Create Mass Offering", required: true
    end
    response 201, "Ok", Schema.ref(:Mass_Offering)
    response 422, "Unprocessable Entity"
  end

  def create(conn, %{"mass_offering" => mass_offering_params}) do
    with {:ok, %MassOffering{} = mass_offering} <- MassOfferings.create_mass_offering(mass_offering_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mass_offering_path(conn, :show, mass_offering))
      |> render("show.json", mass_offering: mass_offering)
    end 
  end

  swagger_path :update do
    patch "/api/mass_offerings/{id}"
    description "Update an existing Mass Offering by ID"
    parameters do
      id :path, :integer, "Mass Offering [ID]", required: true
      mass_offering :body, Schema.ref(:Mass_Offering), "Editing Mass Offering", required: true
    end
    response 201, "Ok", Schema.ref(:Mass_Offering)
    response 422, "Unprocessable Entity"
  end

  def update(conn, %{"id" => id, "mass_offering" => mass_offering_params}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{} = mass_offering} <- MassOfferings.update_mass_offering(mass_offering, mass_offering_params) do
      render(conn, "show.json", mass_offering: mass_offering)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/mass_offerings/{id}"
    description "Delete an existing Mass Offering by ID"
    parameter :id, :path, :integer, "Mass Offering ID", required: true
    response 204, "No Content"
    response 404, "Not found"
  end

  def delete(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{}} <- MassOfferings.delete_mass_offering(mass_offering) do
      send_resp(conn, :no_content, "")
    end
  end

  def swagger_definitions do
    %{
      Mass_Offering: swagger_schema do
        title "Mass Offering"
        description "Record the mass offering by user"
        properties do
          contactNumber :string, "Contact Number", required: true
          emailAddress :string, "Email Address", required: true
          fromWhom :string, "Offer by", required: true
          massLanguage :string, "Mass Language", required: true
          offerings (Schema.new do
            properties do
              typeOfMass :string, "Type of Mass"
              intention :string, "Intention"
              dates :array, "Select Date"
            end
          end)
        end
        example %{
          mass_offering: %{
            contactNumber: "0102020333",
            emailAddress: "zen9.felix@gmail.com",
            fromWhom: "Felix",
            massLanguage: "English",
            offerings: [
              %{
                  typeOfMass: "Special Intention",
                  intention: "this is a special intention",
                  dates: [
                      "2021-06-01",
                      "2021-06-02"
                  ]
              },
              %{
                  typeOfMass: "Thanksgiving",
                  intention: "this is thanksgiving",
                  dates: [
                      "2021-06-01",
                      "2021-06-02"
                  ]
              },
              %{
                  typeOfMass: "Departed Soul",
                  intention: "this is for departed soul",
                  dates: [
                      "2021-06-01",
                      "2021-06-02"
                  ]
              }
            ]
          }
        }
      end
    }
  end

end
