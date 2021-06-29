defmodule DonationWeb.TypeOfPaymentMethodController do
  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Admins.TypeOfPaymentMethod

  def index(conn, _params) do
    type_of_payment_methods = Admins.list_type_of_payment_methods()
    render(conn, "index.html", type_of_payment_methods: type_of_payment_methods)
  end

  def new(conn, _params) do
    changeset = Admins.change_type_of_payment_method(%TypeOfPaymentMethod{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"type_of_payment_method" => type_of_payment_method_params}) do
    case Admins.create_type_of_payment_method(type_of_payment_method_params) do
      {:ok, type_of_payment_method} ->
        conn
        |> put_flash(:info, "Type of payment method created successfully.")
        |> redirect(to: Routes.type_of_payment_method_path(conn, :show, type_of_payment_method))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    type_of_payment_method = Admins.get_type_of_payment_method!(id)
    render(conn, "show.html", type_of_payment_method: type_of_payment_method)
  end

  def edit(conn, %{"id" => id}) do
    type_of_payment_method = Admins.get_type_of_payment_method!(id)
    changeset = Admins.change_type_of_payment_method(type_of_payment_method)

    render(conn, "edit.html", type_of_payment_method: type_of_payment_method, changeset: changeset)
  end

  def update(conn, %{"id" => id, "type_of_payment_method" => type_of_payment_method_params}) do
    type_of_payment_method = Admins.get_type_of_payment_method!(id)

    case Admins.update_type_of_payment_method(
           type_of_payment_method,
           type_of_payment_method_params
         ) do
      {:ok, type_of_payment_method} ->
        conn
        |> put_flash(:info, "Type of payment method updated successfully.")
        |> redirect(to: Routes.type_of_payment_method_path(conn, :show, type_of_payment_method))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          type_of_payment_method: type_of_payment_method,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    type_of_payment_method = Admins.get_type_of_payment_method!(id)
    {:ok, _type_of_payment_method} = Admins.delete_type_of_payment_method(type_of_payment_method)

    conn
    |> put_flash(:info, "Type of payment method deleted successfully.")
    |> redirect(to: Routes.type_of_payment_method_path(conn, :index))
  end
end
