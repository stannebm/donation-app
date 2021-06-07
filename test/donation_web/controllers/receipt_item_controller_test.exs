defmodule DonationWeb.ReceiptItemControllerTest do
  use DonationWeb.ConnCase

  alias Donation.Admins

  @create_attrs %{others: "some others", price: 42, remark: "some remark", type_of_contribution: 42}
  @update_attrs %{others: "some updated others", price: 43, remark: "some updated remark", type_of_contribution: 43}
  @invalid_attrs %{others: nil, price: nil, remark: nil, type_of_contribution: nil}

  def fixture(:receipt_item) do
    {:ok, receipt_item} = Admins.create_receipt_item(@create_attrs)
    receipt_item
  end

  describe "index" do
    test "lists all receipt_items", %{conn: conn} do
      conn = get(conn, Routes.receipt_item_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Receipt items"
    end
  end

  describe "new receipt_item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.receipt_item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Receipt item"
    end
  end

  describe "create receipt_item" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.receipt_item_path(conn, :create), receipt_item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.receipt_item_path(conn, :show, id)

      conn = get(conn, Routes.receipt_item_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Receipt item"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.receipt_item_path(conn, :create), receipt_item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Receipt item"
    end
  end

  describe "edit receipt_item" do
    setup [:create_receipt_item]

    test "renders form for editing chosen receipt_item", %{conn: conn, receipt_item: receipt_item} do
      conn = get(conn, Routes.receipt_item_path(conn, :edit, receipt_item))
      assert html_response(conn, 200) =~ "Edit Receipt item"
    end
  end

  describe "update receipt_item" do
    setup [:create_receipt_item]

    test "redirects when data is valid", %{conn: conn, receipt_item: receipt_item} do
      conn = put(conn, Routes.receipt_item_path(conn, :update, receipt_item), receipt_item: @update_attrs)
      assert redirected_to(conn) == Routes.receipt_item_path(conn, :show, receipt_item)

      conn = get(conn, Routes.receipt_item_path(conn, :show, receipt_item))
      assert html_response(conn, 200) =~ "some updated others"
    end

    test "renders errors when data is invalid", %{conn: conn, receipt_item: receipt_item} do
      conn = put(conn, Routes.receipt_item_path(conn, :update, receipt_item), receipt_item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Receipt item"
    end
  end

  describe "delete receipt_item" do
    setup [:create_receipt_item]

    test "deletes chosen receipt_item", %{conn: conn, receipt_item: receipt_item} do
      conn = delete(conn, Routes.receipt_item_path(conn, :delete, receipt_item))
      assert redirected_to(conn) == Routes.receipt_item_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.receipt_item_path(conn, :show, receipt_item))
      end
    end
  end

  defp create_receipt_item(_) do
    receipt_item = fixture(:receipt_item)
    %{receipt_item: receipt_item}
  end
end
