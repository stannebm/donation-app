defmodule DonationWeb.MassOfferingItemControllerTest do
  use DonationWeb.ConnCase

  alias Donation.MassOfferings
  alias Donation.MassOfferings.MassOfferingItem

  @create_attrs %{
    intention: "some intention",
    number_of_mass: 42,
    specific_dates: ~D[2010-04-17],
    to_whom: "some to_whom",
    type_of_mass: "some type_of_mass"
  }
  @update_attrs %{
    intention: "some updated intention",
    number_of_mass: 43,
    specific_dates: ~D[2011-05-18],
    to_whom: "some updated to_whom",
    type_of_mass: "some updated type_of_mass"
  }
  @invalid_attrs %{intention: nil, number_of_mass: nil, specific_dates: nil, to_whom: nil, type_of_mass: nil}

  def fixture(:mass_offering_item) do
    {:ok, mass_offering_item} = MassOfferings.create_mass_offering_item(@create_attrs)
    mass_offering_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mass_offering_items", %{conn: conn} do
      conn = get(conn, Routes.mass_offering_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mass_offering_item" do
    test "renders mass_offering_item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.mass_offering_item_path(conn, :create), mass_offering_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.mass_offering_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "intention" => "some intention",
               "number_of_mass" => 42,
               "specific_dates" => "2010-04-17",
               "to_whom" => "some to_whom",
               "type_of_mass" => "some type_of_mass"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.mass_offering_item_path(conn, :create), mass_offering_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mass_offering_item" do
    setup [:create_mass_offering_item]

    test "renders mass_offering_item when data is valid", %{conn: conn, mass_offering_item: %MassOfferingItem{id: id} = mass_offering_item} do
      conn = put(conn, Routes.mass_offering_item_path(conn, :update, mass_offering_item), mass_offering_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.mass_offering_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "intention" => "some updated intention",
               "number_of_mass" => 43,
               "specific_dates" => "2011-05-18",
               "to_whom" => "some updated to_whom",
               "type_of_mass" => "some updated type_of_mass"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, mass_offering_item: mass_offering_item} do
      conn = put(conn, Routes.mass_offering_item_path(conn, :update, mass_offering_item), mass_offering_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mass_offering_item" do
    setup [:create_mass_offering_item]

    test "deletes chosen mass_offering_item", %{conn: conn, mass_offering_item: mass_offering_item} do
      conn = delete(conn, Routes.mass_offering_item_path(conn, :delete, mass_offering_item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.mass_offering_item_path(conn, :show, mass_offering_item))
      end
    end
  end

  defp create_mass_offering_item(_) do
    mass_offering_item = fixture(:mass_offering_item)
    %{mass_offering_item: mass_offering_item}
  end
end
