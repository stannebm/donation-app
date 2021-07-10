defmodule DonationWeb.ReportController do
  use DonationWeb, :controller

  import Ecto.Query
  alias Donation.Repo
  alias Donation.Admins
  # alias Donation.Admins.{Receipt}
  alias Donation.Revenue.MassOffering

  # action_fallback DonationWeb.FallbackController

  def index(conn, params) do
    receipts = Admins.search_receipts(params)
    render(conn, "index.html", receipts: receipts)
  end

  ## List Mass Offerings -> CASE 1
  def list_mass_offerings(conn, %{"search" => search}) do
    new_date = Date.from_iso8601!(search["from_date"])
    query = Admins.find_mass_offering_dates(new_date)
    render(conn, :list_mass_offerings, mass_offerings: query)
  end

  ## List Mass Offerings -> CASE 2
  def list_mass_offerings(conn, _) do
    default_date = Date.utc_today()
    query = Admins.find_mass_offering_dates(default_date)
    render(conn, :list_mass_offerings, mass_offerings: query)
  end

  ## GENERATE PDF
  def list_mass_offerings_pdf(conn, params) do
    from_date = get_in(params, ["search", "from_date"])
    new_date = Date.from_iso8601!(from_date)
    query = Admins.find_mass_offering_dates(new_date)

    html =
      Phoenix.View.render_to_string(DonationWeb.ReportView, "list_mass_offerings_pdf.html",
        layout: {DonationWeb.LayoutView, "pdf.html"},
        conn: conn,
        mass_offerings_eng_tg: Admins.filter_mass_intentions(query, "English", "Thanksgiving"),
        mass_offerings_eng_si:
          Admins.filter_mass_intentions(query, "English", "Special Intention"),
        mass_offerings_eng_ds: Admins.filter_mass_intentions(query, "English", "Departed Soul"),
        mass_offerings_chi_tg: Admins.filter_mass_intentions(query, "Mandarin", "Thanksgiving"),
        mass_offerings_chi_si:
          Admins.filter_mass_intentions(query, "Mandarin", "Special Intention"),
        mass_offerings_chi_ds: Admins.filter_mass_intentions(query, "Mandarin", "Departed Soul"),
        mass_offerings_tml_tg: Admins.filter_mass_intentions(query, "Tamil", "Thanksgiving"),
        mass_offerings_tml_si: Admins.filter_mass_intentions(query, "Tamil", "Special Intention"),
        mass_offerings_tml_ds: Admins.filter_mass_intentions(query, "Tamil", "Departed Soul"),
        mass_offerings_bm_tg: Admins.filter_mass_intentions(query, "Bahasa", "Thanksgiving"),
        mass_offerings_bm_si: Admins.filter_mass_intentions(query, "Bahasa", "Special Intention"),
        mass_offerings_bm_ds: Admins.filter_mass_intentions(query, "Bahasa", "Departed Soul"),
        current_date: new_date
      )

    {:ok, filename} = PdfGenerator.generate(html, page_size: "A4")

    conn
    |> send_download({:file, filename},
      disposition: :inline,
      filename: "Mass_Intentions.pdf"
    )
  end

  def list_mass_offerings_xlsx(conn, params) do
    from_date = get_in(params, ["search", "from_date"])
    new_date = Date.from_iso8601!(from_date)
    mass_offerings = Admins.find_mass_offering_dates(new_date)

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=mass_intention.xlsx;")
    |> render("mass_intention.xlsx", %{mass_offerings: mass_offerings})
  end
end
