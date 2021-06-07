defmodule DonationWeb.TypeOfContributionControllerTest do
  use DonationWeb.ConnCase

  alias Donation.Admins

  @create_attrs %{name: "some name", price: "120.5"}
  @update_attrs %{name: "some updated name", price: "456.7"}
  @invalid_attrs %{name: nil, price: nil}

  def fixture(:type_of_contribution) do
    {:ok, type_of_contribution} = Admins.create_type_of_contribution(@create_attrs)
    type_of_contribution
  end

  describe "index" do
    test "lists all type_of_contributions", %{conn: conn} do
      conn = get(conn, Routes.type_of_contribution_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Type of contributions"
    end
  end

  describe "new type_of_contribution" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.type_of_contribution_path(conn, :new))
      assert html_response(conn, 200) =~ "New Type of contribution"
    end
  end

  describe "create type_of_contribution" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.type_of_contribution_path(conn, :create), type_of_contribution: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.type_of_contribution_path(conn, :show, id)

      conn = get(conn, Routes.type_of_contribution_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Type of contribution"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.type_of_contribution_path(conn, :create), type_of_contribution: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Type of contribution"
    end
  end

  describe "edit type_of_contribution" do
    setup [:create_type_of_contribution]

    test "renders form for editing chosen type_of_contribution", %{conn: conn, type_of_contribution: type_of_contribution} do
      conn = get(conn, Routes.type_of_contribution_path(conn, :edit, type_of_contribution))
      assert html_response(conn, 200) =~ "Edit Type of contribution"
    end
  end

  describe "update type_of_contribution" do
    setup [:create_type_of_contribution]

    test "redirects when data is valid", %{conn: conn, type_of_contribution: type_of_contribution} do
      conn = put(conn, Routes.type_of_contribution_path(conn, :update, type_of_contribution), type_of_contribution: @update_attrs)
      assert redirected_to(conn) == Routes.type_of_contribution_path(conn, :show, type_of_contribution)

      conn = get(conn, Routes.type_of_contribution_path(conn, :show, type_of_contribution))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, type_of_contribution: type_of_contribution} do
      conn = put(conn, Routes.type_of_contribution_path(conn, :update, type_of_contribution), type_of_contribution: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Type of contribution"
    end
  end

  describe "delete type_of_contribution" do
    setup [:create_type_of_contribution]

    test "deletes chosen type_of_contribution", %{conn: conn, type_of_contribution: type_of_contribution} do
      conn = delete(conn, Routes.type_of_contribution_path(conn, :delete, type_of_contribution))
      assert redirected_to(conn) == Routes.type_of_contribution_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.type_of_contribution_path(conn, :show, type_of_contribution))
      end
    end
  end

  defp create_type_of_contribution(_) do
    type_of_contribution = fixture(:type_of_contribution)
    %{type_of_contribution: type_of_contribution}
  end
end
