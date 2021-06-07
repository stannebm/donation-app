defmodule DonationWeb.TypeOfContributionController do
  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Admins.TypeOfContribution

  def index(conn, _params) do
    type_of_contributions = Admins.list_type_of_contributions()
    render(conn, "index.html", type_of_contributions: type_of_contributions)
  end

  def new(conn, _params) do
    changeset = Admins.change_type_of_contribution(%TypeOfContribution{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"type_of_contribution" => type_of_contribution_params}) do
    case Admins.create_type_of_contribution(type_of_contribution_params) do
      {:ok, type_of_contribution} ->
        conn
        |> put_flash(:info, "Type of contribution created successfully.")
        |> redirect(to: Routes.type_of_contribution_path(conn, :show, type_of_contribution))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    type_of_contribution = Admins.get_type_of_contribution!(id)
    render(conn, "show.html", type_of_contribution: type_of_contribution)
  end

  def edit(conn, %{"id" => id}) do
    type_of_contribution = Admins.get_type_of_contribution!(id)
    changeset = Admins.change_type_of_contribution(type_of_contribution)
    render(conn, "edit.html", type_of_contribution: type_of_contribution, changeset: changeset)
  end

  def update(conn, %{"id" => id, "type_of_contribution" => type_of_contribution_params}) do
    type_of_contribution = Admins.get_type_of_contribution!(id)

    case Admins.update_type_of_contribution(type_of_contribution, type_of_contribution_params) do
      {:ok, type_of_contribution} ->
        conn
        |> put_flash(:info, "Type of contribution updated successfully.")
        |> redirect(to: Routes.type_of_contribution_path(conn, :show, type_of_contribution))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", type_of_contribution: type_of_contribution, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    type_of_contribution = Admins.get_type_of_contribution!(id)
    {:ok, _type_of_contribution} = Admins.delete_type_of_contribution(type_of_contribution)

    conn
    |> put_flash(:info, "Type of contribution deleted successfully.")
    |> redirect(to: Routes.type_of_contribution_path(conn, :index))
  end
end
