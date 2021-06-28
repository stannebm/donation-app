defmodule DonationWeb.ContributionApiController do
  use DonationWeb, :controller
  use PhoenixSwagger

  alias Donation.Contribution
  alias Donation.Contribution.Offering

  action_fallback(DonationWeb.FallbackController)

  # swagger_path :index do
  #   get("/api/offerings")
  #   description("List of Offerings")
  #   response(200, "Success")
  # end

  def index(conn, _params) do
    render(conn, "index.json", offerings: Contribution.list_offerings())
  end

  # swagger_path :show do
  #   get("/api/offerings/{reference_no}")
  #   description("Get a mass offering by reference no. Following the result of offerings.")
  #   parameter(:id, :path, :integer, "Mass Offering [ID]", required: true)
  #   response(200, "Success")
  #   response(404, "Not found")
  # end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", offering: Contribution.get_offering!(id))
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

  def create(conn, %{"offering" => params}) do
    with {:ok, %Offering{} = o} <-
           Contribution.create_offering(params) do
      conn
      |> put_status(:created)
      |> render("show.json", offering: o)
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

  def update(conn, %{"id" => id, "offering" => params}) do
    old = Contribution.get_offering!(id)

    with {:ok, %Offering{} = o} <-
           Contribution.update_offering(old, params) do
      render(conn, "show.json", offering: o)
    end
  end

  # swagger_path :delete do
  #   PhoenixSwagger.Path.delete("/api/mass_offerings/{id}")
  #   description("Delete an existing Mass Offering by ID")
  #   parameter(:id, :path, :integer, "Mass Offering ID", required: true)
  #   response(204, "No Content")
  #   response(404, "Not found")
  # end

  def delete(conn, %{"id" => id}) do
    old = Contribution.get_offering!(id)

    with {:ok, %Offering{}} <- Contribution.delete_offering(old) do
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

  def fpx(conn, %{
        "reference_no" => ref,
        "txn_info" => %{"status" => status, "info" => info}
      }) do
    old = Contribution.get_offering_by_reference_no(ref)

    with {:ok, %Offering{} = o} <-
           Contribution.update_with_txn_info(old, :fpx, status == "OK", info) do
      render(conn, "show.json", offering: o)
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

  def cybersource(conn, %{
        "reference_no" => ref,
        "txn_info" => %{"status" => status, "info" => info}
      }) do
    old = Contribution.get_offering_by_reference_no(ref)

    with {:ok, %Offering{} = o} <-
           Contribution.update_with_txn_info(old, :cybersource, status == "OK", info) do
      render(conn, "show.json", offering: o)
    end
  end

  # def swagger_definitions do
  #   %{
  #     Mass_Offering:
  #       swagger_schema do
  #         title("Mass Offering")
  #         description("Record the mass offering by user")

  #         properties do
  #           contactNumber(:string, "Contact Number", required: true)
  #           emailAddress(:string, "Email Address", required: true)
  #           fromWhom(:string, "Offer by", required: true)
  #           massLanguage(:string, "Mass Language", required: true)
  #           uuid(:string, "UUID", required: true)
  #           amount(:decimal, "Amount", required: true)
  #           fpx_callback(:map)
  #           cybersource_callback(:map)

  #           offerings(
  #             Schema.new do
  #               properties do
  #                 typeOfMass(:string, "Type of Mass")
  #                 intention(:string, "Intention")
  #                 otherIntention(:string, "Other Intention")
  #                 dates(:array, "Select Date")
  #               end
  #             end
  #           )
  #         end

  #         example(%{
  #           mass_offering: %{
  #             contactNumber: "0102020333",
  #             emailAddress: "zen9.felix@gmail.com",
  #             fromWhom: "Felix",
  #             massLanguage: "English",
  #             uuid: "9357666c-9103-46a4-a7e8-ca7f8832283c",
  #             amount: 50.00,
  #             fpx_callback: %{
  #               fpx_txnCurrency: "MYR",
  #               fpx_sellerId: "SE0013401",
  #               fpx_sellerExId: "EX0011982"
  #             },
  #             cybersource_callback: %{
  #               cybersource_txnCurrency: "MYR",
  #               cybersource_sellerId: "CSI1846",
  #               cybersource_sellerExId: "CSE1846"
  #             },
  #             offerings: [
  #               %{
  #                 typeOfMass: "Special Intention",
  #                 intention: "this is a special intention",
  #                 otherIntention: "this is an other intention",
  #                 dates: [
  #                   "2021-06-01",
  #                   "2021-06-02"
  #                 ]
  #               },
  #               %{
  #                 typeOfMass: "Thanksgiving",
  #                 intention: "this is thanksgiving",
  #                 otherIntention: "this is an other intention",
  #                 dates: [
  #                   "2021-06-01",
  #                   "2021-06-02"
  #                 ]
  #               },
  #               %{
  #                 typeOfMass: "Departed Soul",
  #                 intention: "this is for departed soul",
  #                 otherIntention: "this is an other intention",
  #                 dates: [
  #                   "2021-06-01",
  #                   "2021-06-02"
  #                 ]
  #               }
  #             ]
  #           }
  #         })
  #       end,
  #     Fpx_Callback:
  #       swagger_schema do
  #         title("FPX Callback")
  #         description("Record the callback from FPX")

  #         properties do
  #           fpx_callback(:map)
  #         end

  #         example(%{
  #           fpx_callback: %{
  #             fpx_txnCurrency: "MYR",
  #             fpx_sellerId: "SE0013401",
  #             fpx_sellerExId: "EX0011982"
  #           }
  #         })
  #       end,
  #     Cybersource_Callback:
  #       swagger_schema do
  #         title("Cybersource Callback")
  #         description("Record the callback from Cybersource")

  #         properties do
  #           cybersource_callback(:map)
  #         end

  #         example(%{
  #           cybersource_callback: %{
  #             cybersource_txnCurrency: "USD",
  #             cybersource_sellerId: "AB0013401",
  #             cybersource_sellerExId: "CS0011982"
  #           }
  #         })
  #       end
  #   }
  # end
end
