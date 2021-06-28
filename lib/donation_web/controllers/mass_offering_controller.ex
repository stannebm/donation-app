require IEx

defmodule DonationWeb.MassOfferingController do
  use DonationWeb, :controller
  use PhoenixSwagger

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOffering

  action_fallback(DonationWeb.FallbackController)

  # swagger_path :index do
  #   get("/api/mass_offerings")
  #   description("List of Mass Offerings")
  #   response(200, "Success")
  # end

  def index(conn, _params) do
    mass_offerings = MassOfferings.list_mass_offerings()
    render(conn, "index.json", mass_offerings: mass_offerings)
  end

  # swagger_path :show do
  #   get("/api/mass_offerings/{id}")
  #   description("Get a mass offering by ID. Following the result of offerings.")
  #   parameter(:id, :path, :integer, "Mass Offering [ID]", required: true)
  #   response(200, "Success")
  #   response(404, "Not found")
  # end

  def show(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)
    render(conn, "show.json", mass_offering: mass_offering)
  end

  # swagger_path :create do
  #   post("/api/mass_offerings")
  #   description("Create new Mass Offering")

  #   parameters do
  #     mass_offering(:body, Schema.ref(:Mass_Offering), "Create Mass Offering", required: true)
  #   end

  #   response(201, "Ok", Schema.ref(:Mass_Offering))
  #   response(422, "Unprocessable Entity")
  # end

  def create(conn, %{"mass_offering" => mass_offering_params}) do
    with {:ok, %MassOffering{} = mass_offering} <-
           MassOfferings.create_mass_offering(mass_offering_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mass_offering_path(conn, :show, mass_offering))
      |> render("show.json", mass_offering: mass_offering)
    end
  end

  # swagger_path :update do
  #   patch("/api/mass_offerings/{id}")
  #   description("Update an existing Mass Offering by ID")

  #   parameters do
  #     id(:path, :integer, "Mass Offering [ID]", required: true)
  #     mass_offering(:body, Schema.ref(:Mass_Offering), "Editing Mass Offering", required: true)
  #   end

  #   response(201, "Ok", Schema.ref(:Mass_Offering))
  #   response(422, "Unprocessable Entity")
  # end

  def update(conn, %{"id" => id, "mass_offering" => mass_offering_params}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{} = mass_offering} <-
           MassOfferings.update_mass_offering(mass_offering, mass_offering_params) do
      render(conn, "show.json", mass_offering: mass_offering)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/mass_offerings/{id}")
    description("Delete an existing Mass Offering by ID")
    parameter(:id, :path, :integer, "Mass Offering ID", required: true)
    response(204, "No Content")
    response(404, "Not found")
  end

  def delete(conn, %{"id" => id}) do
    mass_offering = MassOfferings.get_mass_offering!(id)

    with {:ok, %MassOffering{}} <- MassOfferings.delete_mass_offering(mass_offering) do
      send_resp(conn, :no_content, "")
    end
  end

  # swagger_path :fpx do
  #   patch("/api/mass_offerings/{reference_no}/fpx")
  #   description("Receive FPX callback and update an existing Mass Offering by reference no")

  #   parameters do
  #     reference_no(:path, :string, "reference no", required: true)
  #     fpx_callback(:body, Schema.ref(:Fpx_Callback), "FPX callback", required: true)
  #   end

  #   response(201, "Ok", Schema.ref(:Mass_Offering))
  #   response(422, "Unprocessable Entity")
  # end

  def fpx(conn, %{"referenceNo" => ref, "fpx_callback" => fpx_callback_params}) do
    mass_offering = MassOfferings.get_mass_offering_reference_no(ref)

    with {:ok, %MassOffering{} = mass_offering} <-
           MassOfferings.update_fpx_callback(mass_offering, fpx_callback_params) do
      render(conn, "show.json", mass_offering: mass_offering)
    end
  end

  # swagger_path :cybersource do
  #   patch("/api/mass_offerings/{referenceNo}/cybersource")

  #   description(
  #     "Receive Cybersource callback and update an existing Mass Offering by reference no"
  #   )

  #   parameters do
  #     reference_no(:path, :string, "reference no", required: true)

  #     cybersource_callback(:body, Schema.ref(:Cybersource_Callback), "Cybersource callback",
  #       required: true
  #     )
  #   end

  #   response(201, "Ok", Schema.ref(:Mass_Offering))
  #   response(422, "Unprocessable Entity")
  # end

  def cybersource(conn, %{"uuid" => uuid, "cybersource_callback" => cybersource_callback_params}) do
    mass_offering = MassOfferings.get_mass_offering_uuid!(uuid)

    with {:ok, %MassOffering{} = mass_offering} <-
           MassOfferings.update_cybersource_callback(mass_offering, cybersource_callback_params) do
      render(conn, "show.json", mass_offering: mass_offering)
    end
  end

  def swagger_definitions do
    %{
      Mass_Offering:
        swagger_schema do
          title("Mass Offering")
          description("Record the mass offering by user")

          properties do
            contactNumber(:string, "Contact Number", required: true)
            emailAddress(:string, "Email Address", required: true)
            fromWhom(:string, "Offer by", required: true)
            massLanguage(:string, "Mass Language", required: true)
            uuid(:string, "UUID", required: true)
            amount(:decimal, "Amount", required: true)
            fpx_callback(:map)
            cybersource_callback(:map)

            offerings(
              Schema.new do
                properties do
                  typeOfMass(:string, "Type of Mass")
                  intention(:string, "Intention")
                  otherIntention(:string, "Other Intention")
                  dates(:array, "Select Date")
                end
              end
            )
          end

          example(%{
            mass_offering: %{
              contactNumber: "0102020333",
              emailAddress: "zen9.felix@gmail.com",
              fromWhom: "Felix",
              massLanguage: "English",
              uuid: "9357666c-9103-46a4-a7e8-ca7f8832283c",
              amount: 50.00,
              fpx_callback: %{
                fpx_txnCurrency: "MYR",
                fpx_sellerId: "SE0013401",
                fpx_sellerExId: "EX0011982"
              },
              cybersource_callback: %{
                cybersource_txnCurrency: "MYR",
                cybersource_sellerId: "CSI1846",
                cybersource_sellerExId: "CSE1846"
              },
              offerings: [
                %{
                  typeOfMass: "Special Intention",
                  intention: "this is a special intention",
                  otherIntention: "this is an other intention",
                  dates: [
                    "2021-06-01",
                    "2021-06-02"
                  ]
                },
                %{
                  typeOfMass: "Thanksgiving",
                  intention: "this is thanksgiving",
                  otherIntention: "this is an other intention",
                  dates: [
                    "2021-06-01",
                    "2021-06-02"
                  ]
                },
                %{
                  typeOfMass: "Departed Soul",
                  intention: "this is for departed soul",
                  otherIntention: "this is an other intention",
                  dates: [
                    "2021-06-01",
                    "2021-06-02"
                  ]
                }
              ]
            }
          })
        end,
      Fpx_Callback:
        swagger_schema do
          title("FPX Callback")
          description("Record the callback from FPX")

          properties do
            fpx_callback(:map)
          end

          example(%{
            fpx_callback: %{
              fpx_txnCurrency: "MYR",
              fpx_sellerId: "SE0013401",
              fpx_sellerExId: "EX0011982"
            }
          })
        end,
      Cybersource_Callback:
        swagger_schema do
          title("Cybersource Callback")
          description("Record the callback from Cybersource")

          properties do
            cybersource_callback(:map)
          end

          example(%{
            cybersource_callback: %{
              cybersource_txnCurrency: "USD",
              cybersource_sellerId: "AB0013401",
              cybersource_sellerExId: "CS0011982"
            }
          })
        end
    }
  end
end
