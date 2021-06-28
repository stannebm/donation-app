# LEARN NESTED FORMS
# https://gist.github.com/mjrode/c2939ee7786b157aab131761c8fb89a9
# work for phoenix 1.4 https://github.com/andkar73/nested_forms

defmodule DonationWeb.ReceiptController do
  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Admins.Receipt
  alias Donation.Admins.ReceiptItem

  def index(conn, _params) do
    receipts = Admins.list_receipts()
    render(conn, "index.html", receipts: receipts)
  end

  def new(conn, _params) do
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})

    changeset =
      Admins.change_receipt(%Receipt{
        user_id: conn.assigns.current_admin.id,
        receipt_items: [%ReceiptItem{}]
      })

    render(conn, "new.html",
      changeset: changeset,
      type_of_contributions: type_of_contributions,
      type_of_payment_methods: type_of_payment_methods
    )
  end

  def create(conn, %{"receipt" => receipt_params}) do
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})

    case Admins.create_receipt(receipt_params) do
      {:ok, receipt} ->
        Admins.put_receipt_number(receipt)

        conn
        |> put_flash(:info, "Receipt created successfully.")
        |> redirect(to: Routes.receipt_path(conn, :show, receipt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    receipt = Admins.get_receipt!(id)
    render(conn, "show.html", receipt: receipt)
  end

  def edit(conn, %{"id" => id}) do
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
    receipt = Admins.get_receipt!(id)
    changeset = Admins.change_receipt(receipt)

    render(conn, "edit.html",
      receipt: receipt,
      changeset: changeset,
      type_of_contributions: type_of_contributions,
      type_of_payment_methods: type_of_payment_methods
    )
  end

  def update(conn, %{"id" => id, "receipt" => receipt_params}) do
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
    receipt = Admins.get_receipt!(id)

    case Admins.update_receipt(receipt, receipt_params) do
      {:ok, receipt} ->
        conn
        |> put_flash(:info, "Receipt updated successfully.")
        |> redirect(to: Routes.receipt_path(conn, :show, receipt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", receipt: receipt, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    receipt = Admins.get_receipt!(id)
    {:ok, _receipt} = Admins.delete_receipt(receipt)

    conn
    |> put_flash(:info, "Receipt deleted successfully.")
    |> redirect(to: Routes.receipt_path(conn, :index))
  end

  def generate_pdf(conn, %{"id" => id}) do
    receipt = Admins.get_receipt!(id)

    html =
      Phoenix.View.render_to_string(DonationWeb.ReceiptView, "generate_pdf.html",
        layout: {DonationWeb.LayoutView, "printable.html"},
        receipt: receipt,
        conn: conn
      )

    {:ok, filename} = PdfGenerator.generate(html)

    conn
    |> send_download({:file, filename},
      disposition: :inline,
      filename: "offical_receipt_#{receipt.receipt_number}.pdf"
    )
  end
end
