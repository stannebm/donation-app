defmodule DonationWeb.ReceiptControllerTest do
  use DonationWeb.ConnCase

  alias Donation.Admins

  @create_attrs %{donor_name: "some donor_name", receipt_number: "some receipt_number", total_amount: 42, type_of_payment_method: 42}
  @update_attrs %{donor_name: "some updated donor_name", receipt_number: "some updated receipt_number", total_amount: 43, type_of_payment_method: 43}
  @invalid_attrs %{donor_name: nil, receipt_number: nil, total_amount: nil, type_of_payment_method: nil}

  def fixture(:receipt) do
    {:ok, receipt} = Admins.create_receipt(@create_attrs)
    receipt
  end

  describe "index" do
    test "lists all receipts", %{conn: conn} do
      conn = get(conn, Routes.receipt_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Receipts"
    end
  end

  describe "new receipt" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.receipt_path(conn, :new))
      assert html_response(conn, 200) =~ "New Receipt"
    end
  end

  describe "create receipt" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.receipt_path(conn, :create), receipt: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.receipt_path(conn, :show, id)

      conn = get(conn, Routes.receipt_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Receipt"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.receipt_path(conn, :create), receipt: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Receipt"
    end
  end

  describe "edit receipt" do
    setup [:create_receipt]

    test "renders form for editing chosen receipt", %{conn: conn, receipt: receipt} do
      conn = get(conn, Routes.receipt_path(conn, :edit, receipt))
      assert html_response(conn, 200) =~ "Edit Receipt"
    end
  end

  describe "update receipt" do
    setup [:create_receipt]

    test "redirects when data is valid", %{conn: conn, receipt: receipt} do
      conn = put(conn, Routes.receipt_path(conn, :update, receipt), receipt: @update_attrs)
      assert redirected_to(conn) == Routes.receipt_path(conn, :show, receipt)

      conn = get(conn, Routes.receipt_path(conn, :show, receipt))
      assert html_response(conn, 200) =~ "some updated donor_name"
    end

    test "renders errors when data is invalid", %{conn: conn, receipt: receipt} do
      conn = put(conn, Routes.receipt_path(conn, :update, receipt), receipt: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Receipt"
    end
  end

  describe "delete receipt" do
    setup [:create_receipt]

    test "deletes chosen receipt", %{conn: conn, receipt: receipt} do
      conn = delete(conn, Routes.receipt_path(conn, :delete, receipt))
      assert redirected_to(conn) == Routes.receipt_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.receipt_path(conn, :show, receipt))
      end
    end
  end

  defp create_receipt(_) do
    receipt = fixture(:receipt)
    %{receipt: receipt}
  end
end
