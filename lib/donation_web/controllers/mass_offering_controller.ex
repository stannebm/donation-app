# LEARN NESTED FORMS
# https://gist.github.com/mjrode/c2939ee7786b157aab131761c8fb89a9
# work for phoenix 1.4 https://github.com/andkar73/nested_forms

defmodule DonationWeb.MassOfferingController do
  @moduledoc """
    Admin need to entry data of mass_offerings for a contributor, no payment required
    - In table, we set default for no payment required, such as email: na@na.na, contact_number: -, amount: 0, payment_method: none

    A contributor can open website to choose mass_offerings and donations using payment gateway: FPX and Credit/Debit Card
  """

  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Revenue.{Contribution, MassOffering}

  # def index(conn, %{"format" => "xlsx", "search" => search}) do
  #   contributors = Admins.list_mass_offering_by_contributors(search)
  #   conn
  #   |> put_resp_content_type("text/xlsx")
  #   |> put_resp_header("content-disposition", "attachment; filename=list_contributors.xlsx;")
  #   |> render("list_contributors.xlsx", %{contributors: contributors})
  # end

  ## GENERATE PDF
  def index(conn, %{"format" => "pdf", "search" => search}) do
    contributors = Admins.list_mass_offering_by_contributors(search)

    html =
      Phoenix.View.render_to_string(DonationWeb.MassOfferingView, "index_pdf.html",
        layout: {DonationWeb.LayoutView, "pdf.html"},
        conn: conn,
        contributors: contributors
      )

    {:ok, filename} = PdfGenerator.generate(html, page_size: "A4")

    conn
    |> send_download({:file, filename},
      disposition: :inline,
      filename: "Contributors.pdf"
    )
  end

  def index(conn, %{"search" => search}) do
    contributions = Admins.list_mass_offering_by_contributors(search)
    render(conn, :index, contributions: contributions)
  end

  def index(conn, _params) do
    contributions = Admins.list_mass_offering_by_contributors()
    render(conn, :index, contributions: contributions)
  end

  def new(conn, _params) do
    changeset =
      Admins.change_mass_offering_by_contributor(%Contribution{
        mass_offerings: [%MassOffering{}]
      })

    render(conn, "new.html", changeset: changeset, language: "English")
  end

  def create(conn, %{"contribution" => contribution_params}) do
    case Admins.create_mass_offering_by_contributor(contribution_params) do
      {:ok, contribution} ->
        conn
        |> put_flash(:info, "Mass Offering created successfully.")
        |> redirect(to: Routes.admin_mass_offering_path(conn, :show, contribution))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "type" => "donation"}) do
    contribution = Admins.get_mass_offering_by_contributor!(id)
    render(conn, "show_donation.html", contribution: contribution)
  end

  def show(conn, %{"id" => id}) do
    contribution = Admins.get_mass_offering_by_contributor!(id)
    render(conn, "show.html", contribution: contribution)
  end

  def edit(conn, %{"id" => id}) do
    contribution = Admins.get_mass_offering_by_contributor!(id)
    language = List.first(contribution.mass_offerings).mass_language || "English"
    changeset = Admins.change_mass_offering_by_contributor(contribution)

    render(conn, "edit.html", contribution: contribution, changeset: changeset, language: language)
  end

  def update(conn, %{"id" => id, "contribution" => contribution_params}) do
    contribution = Admins.get_mass_offering_by_contributor!(id)

    with {:ok, %Contribution{} = contribution} <-
           Admins.update_mass_offering_by_contributor(contribution, contribution_params) do
      render(conn, :show, contribution: contribution)
    end
  end

  def delete(conn, %{"id" => id}) do
    contribution = Admins.get_mass_offering_by_contributor!(id)
    {:ok, _contribution} = Admins.delete_mass_offering_by_contributor(contribution)

    conn
    |> put_flash(:info, "Receipt deleted successfully.")
    |> redirect(to: Routes.admin_mass_offering_path(conn, :index))
  end

end
