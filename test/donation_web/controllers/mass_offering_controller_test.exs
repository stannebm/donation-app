defmodule DonationWeb.MassOfferingControllerTest do
  use DonationWeb.ConnCase

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOffering

  @create_attrs %{
    mass_offering: %{
      fromWhom: "felix the cat", 
      emailAddress: "felix.the.cat@cartoon.com",
      contactNumber: "19192001",
      massLanguage: "English", 
      offerings: [
        {
          "typeOfMass": "Special Intention",
          "intention": "this is a special intention",
          "dates": ["2021-06-01", "2021-06-02"]
        },
        {
          "typeOfMass": "Thanksgiving",
          "intention": "this is thanksgiving",
          "dates": ["2021-06-01", "2021-06-02"]
        },
        {
          "typeOfMass": "Departed Soul",
          "intention": "this is for departed soul",
          "dates": ["2021-06-01", "2021-06-02"]
        }
      ]
    }
  }

  @update_attrs %{
    contact_name: "some updated contact_name",
    contact_number: "some updated contact_number",
    email_address: "some updated email_address"
  }
  @invalid_attrs %{contact_name: nil, contact_number: nil, email_address: nil}

  def fixture(:mass_offering) do
    {:ok, mass_offering} = MassOfferings.create_mass_offering(@create_attrs)
    mass_offering
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mass_offerings", %{conn: conn} do
      conn = get(conn, Routes.mass_offering_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mass_offering" do
    test "renders mass_offering when data is valid", %{conn: conn} do
      conn = post(conn, Routes.mass_offering_path(conn, :create), mass_offering: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.mass_offering_path(conn, :show, id))

      assert %{
               "id" => id,
               "contact_name" => "some contact_name",
               "contact_number" => "some contact_number",
               "email_address" => "some email_address"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.mass_offering_path(conn, :create), mass_offering: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mass_offering" do
    setup [:create_mass_offering]

    test "renders mass_offering when data is valid", %{conn: conn, mass_offering: %MassOffering{id: id} = mass_offering} do
      conn = put(conn, Routes.mass_offering_path(conn, :update, mass_offering), mass_offering: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.mass_offering_path(conn, :show, id))

      assert %{
               "id" => id,
               "contact_name" => "some updated contact_name",
               "contact_number" => "some updated contact_number",
               "email_address" => "some updated email_address"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, mass_offering: mass_offering} do
      conn = put(conn, Routes.mass_offering_path(conn, :update, mass_offering), mass_offering: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mass_offering" do
    setup [:create_mass_offering]

    test "deletes chosen mass_offering", %{conn: conn, mass_offering: mass_offering} do
      conn = delete(conn, Routes.mass_offering_path(conn, :delete, mass_offering))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.mass_offering_path(conn, :show, mass_offering))
      end
    end
  end

  defp create_mass_offering(_) do
    mass_offering = fixture(:mass_offering)
    %{mass_offering: mass_offering}
  end
end
