defmodule DonationWeb.TypeOfPaymentMethodControllerTest do
  use DonationWeb.ConnCase

  alias Donation.Admins

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:type_of_payment_method) do
    {:ok, type_of_payment_method} = Admins.create_type_of_payment_method(@create_attrs)
    type_of_payment_method
  end

  describe "index" do
    test "lists all type_of_payment_methods", %{conn: conn} do
      conn = get(conn, Routes.type_of_payment_method_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Type of payment methods"
    end
  end

  describe "new type_of_payment_method" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.type_of_payment_method_path(conn, :new))
      assert html_response(conn, 200) =~ "New Type of payment method"
    end
  end

  describe "create type_of_payment_method" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.type_of_payment_method_path(conn, :create), type_of_payment_method: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.type_of_payment_method_path(conn, :show, id)

      conn = get(conn, Routes.type_of_payment_method_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Type of payment method"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.type_of_payment_method_path(conn, :create), type_of_payment_method: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Type of payment method"
    end
  end

  describe "edit type_of_payment_method" do
    setup [:create_type_of_payment_method]

    test "renders form for editing chosen type_of_payment_method", %{conn: conn, type_of_payment_method: type_of_payment_method} do
      conn = get(conn, Routes.type_of_payment_method_path(conn, :edit, type_of_payment_method))
      assert html_response(conn, 200) =~ "Edit Type of payment method"
    end
  end

  describe "update type_of_payment_method" do
    setup [:create_type_of_payment_method]

    test "redirects when data is valid", %{conn: conn, type_of_payment_method: type_of_payment_method} do
      conn = put(conn, Routes.type_of_payment_method_path(conn, :update, type_of_payment_method), type_of_payment_method: @update_attrs)
      assert redirected_to(conn) == Routes.type_of_payment_method_path(conn, :show, type_of_payment_method)

      conn = get(conn, Routes.type_of_payment_method_path(conn, :show, type_of_payment_method))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, type_of_payment_method: type_of_payment_method} do
      conn = put(conn, Routes.type_of_payment_method_path(conn, :update, type_of_payment_method), type_of_payment_method: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Type of payment method"
    end
  end

  describe "delete type_of_payment_method" do
    setup [:create_type_of_payment_method]

    test "deletes chosen type_of_payment_method", %{conn: conn, type_of_payment_method: type_of_payment_method} do
      conn = delete(conn, Routes.type_of_payment_method_path(conn, :delete, type_of_payment_method))
      assert redirected_to(conn) == Routes.type_of_payment_method_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.type_of_payment_method_path(conn, :show, type_of_payment_method))
      end
    end
  end

  defp create_type_of_payment_method(_) do
    type_of_payment_method = fixture(:type_of_payment_method)
    %{type_of_payment_method: type_of_payment_method}
  end
end
