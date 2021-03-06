defmodule DonationWeb.ReportController do
  use DonationWeb, :controller

  alias Donation.Admins

  def index(conn, params) do
    receipts = Admins.search_receipts(params)
    render(conn, "index.html", receipts: receipts)
  end

  ## NORMAL REPORTS

  ## LIST DONATIONS -> CASE 1
  def list_donations(conn, %{"search" => search}) do
    query = Admins.filter_donations(search)
            |> Admins.reject_verified_is_false()
    render(conn, :list_donations, donations: query)
  end

  ## LIST DONATIONS -> CASE 2
  def list_donations(conn, _) do
    query = Admins.filter_donations()
            |> Admins.reject_verified_is_false()
    render(conn, :list_donations, donations: query)
  end

  ## LIST DONATIONS -> EXPORT EXCEL
  def list_donations_xlsx(conn, %{"search" => search}) do
    dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
    query = Admins.filter_donations(search)
            |> Admins.reject_verified_is_false()
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=donations_#{dateformat}.xlsx;")
    |> render("donations.xlsx", %{donations: query})
  end

  ## LIST MASS OFFERINGS -> CASE 1
  def list_mass_offerings(conn, %{"search" => search}) do
    new_date = Date.from_iso8601!(search["from_date"])
    query = Admins.find_mass_offering_dates(new_date)
            |> Admins.reject_verified_is_false()
    render(conn, :list_mass_offerings, mass_offerings: query)
  end

  ## LIST MASS OFFERINGS -> CASE 2
  def list_mass_offerings(conn, _) do
    default_date = Date.utc_today()
    query = Admins.find_mass_offering_dates(default_date)
            |> Admins.reject_verified_is_false()
    render(conn, :list_mass_offerings, mass_offerings: query)
  end

  ## LIST MASS OFFERINGS: GENERATE PDF
  def list_mass_offerings_pdf(conn, params) do
    from_date = get_in(params, ["search", "from_date"])
    new_date = Date.from_iso8601!(from_date)
    query = Admins.find_mass_offering_dates(new_date)
            |> Admins.reject_verified_is_false()
    html =
      Phoenix.View.render_to_string(DonationWeb.ReportView, "list_mass_offerings_pdf.html",
        layout: {DonationWeb.LayoutView, "pdf.html"},
        conn: conn,
        mass_offerings_eng_tg: Admins.filter_mass_intentions(query, "English", "Thanksgiving"),
        mass_offerings_eng_si: Admins.filter_mass_intentions(query, "English", "Special Intention"),
        mass_offerings_eng_ds: Admins.filter_mass_intentions(query, "English", "Departed Soul"),
        mass_offerings_chi_tg: Admins.filter_mass_intentions(query, "Mandarin", "Thanksgiving"),
        mass_offerings_chi_si: Admins.filter_mass_intentions(query, "Mandarin", "Special Intention"),
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

  ## LIST MASS OFFERINGS: EXPORT XLSX
  def list_mass_offerings_xlsx(conn, params) do
    from_date = get_in(params, ["search", "from_date"])
    new_date = Date.from_iso8601!(from_date)
    mass_offerings = Admins.find_mass_offering_dates(new_date)
                     |> Admins.reject_verified_is_false()
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=mass_intention.xlsx;")
    |> render("mass_intention.xlsx", %{mass_offerings: mass_offerings})
  end

  ## FINANCIAL REPORTS

  def list_receipts_and_contributions(conn, %{"search" => search}) do
    cashiers = Admins.unique_cashier_in_receipt()
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    receipt_items = Admins.filter_receipt_and_contribution(search)
    total_payments = Enum.map(type_of_payment_methods, fn {k, v} -> { k, Admins.sum_of_payment_method(receipt_items, v) } end)
    render(conn, :list_receipts_and_contributions, 
      cashiers: cashiers,
      receipt_items: receipt_items, 
      type_of_contributions: type_of_contributions,
      total_payments: total_payments
    )
  end

  def list_receipts_and_contributions(conn, _) do
    cashiers = Admins.unique_cashier_in_receipt()
    type_of_contributions = Admins.list_type_of_contributions() |> Enum.map(&{&1.name, &1.id})
    receipt_items = Admins.filter_receipt_and_contribution()
    render(conn, :list_receipts_and_contributions, 
      cashiers: cashiers,
      receipt_items: receipt_items, 
      type_of_contributions: type_of_contributions,
      total_payments: %{}
    )
  end

  def list_receipts_and_contributions_xlsx(conn, %{"search" => search}) do
    dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
    type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
    receipt_items = Admins.filter_receipt_and_contribution(search)
    total_payments = Enum.map(type_of_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method(receipt_items, v) 
    } end)
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=receipts_and_contributions_#{dateformat}.xlsx;")
    |> render("receipts_and_contributions.xlsx", %{
      receipt_items: receipt_items,
      total_payments: total_payments
    })
  end

  def list_mass_offerings_financial(conn, %{"search" => search}) do
    mass_offerings = Admins.filter_mass_offerings(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_mass_offering(mass_offerings, k) 
    } end)
    render(conn, :list_mass_offerings_financial, 
      mass_offerings: mass_offerings,
      total_payments: total_payments
    )
  end

  def list_mass_offerings_financial(conn, _params) do
    mass_offerings = Admins.filter_mass_offerings()
    render(conn, :list_mass_offerings_financial, 
      mass_offerings: mass_offerings,
      total_payments: %{}
    )
  end

  def list_mass_offerings_financial_xlsx(conn, %{"search" => search}) do
    dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
    mass_offerings = Admins.filter_mass_offerings(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_mass_offering(mass_offerings, k) 
    } end)
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=financial_mass_offerings_#{dateformat}.xlsx;")
    |> render("financial_mass_offerings.xlsx", %{
      mass_offerings: mass_offerings,
      total_payments: total_payments
    })
  end

  def list_donations_financial(conn, %{"search" => search}) do
    donations = Admins.filter_financial_donations(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_donation(donations, k) 
    } end)
    render(conn, :list_donations_financial,
      donations: donations,
      total_payments: total_payments
    )
  end

  def list_donations_financial(conn, _params) do
    donations = Admins.filter_financial_donations()
    render(conn, :list_donations_financial, 
      donations: donations,
      total_payments: %{}
    )
  end

  def list_donations_financial_xlsx(conn, %{"search" => search}) do
    dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
    donations = Admins.filter_financial_donations(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_donation(donations, k) 
    } end)
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=financial_donations_#{dateformat}.xlsx;")
    |> render("financial_donations.xlsx", %{
      donations: donations,
      total_payments: total_payments
    })
  end

  # PAYMENT MANAGEMENT

  def list_payments(conn, %{"search" => search}) do
    payments = Admins.filter_payments(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_donation(payments, k) 
    } end)
    render(conn, :list_payments,
      payments: payments,
      total_payments: total_payments
    )
  end

  def list_payments(conn, _params) do
    payments = Admins.filter_payments()
    render(conn, :list_payments, 
      payments: payments,
      total_payments: %{}
    )
  end

  def list_payments_xlsx(conn, %{"search" => search}) do
    dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
    payments = Admins.filter_payments(search)
    type_payment_methods = %{"cybersource" => 0, "fpx" => 0}
    total_payments = Enum.map(type_payment_methods, fn {k, v} -> { 
      k, Admins.sum_of_payment_method_by_donation(payments, k) 
    } end)
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=payment_report_#{dateformat}.xlsx;")
    |> render("financial_payments.xlsx", %{
      payments: payments,
      total_payments: total_payments
    })
  end


  # def list_receipts_and_payment_methods(conn, %{"search" => search}) do
  #   cashiers = Admins.unique_cashier_in_receipt()
  #   type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
  #   receipts = Admins.filter_receipt_and_payment_method(search)
  #   render(conn, :list_receipts_and_payment_methods, 
  #     receipts: receipts, 
  #     cashiers: cashiers, 
  #     type_of_payment_methods: type_of_payment_methods
  #   )
  # end

  # def list_receipts_and_payment_methods(conn, _) do
  #   cashiers = Admins.unique_cashier_in_receipt()
  #   type_of_payment_methods = Admins.list_type_of_payment_methods() |> Enum.map(&{&1.name, &1.id})
  #   receipts = Admins.filter_receipt_and_payment_method()
  #   render(conn, :list_receipts_and_payment_methods, 
  #     receipts: receipts, 
  #     cashiers: cashiers,
  #     type_of_payment_methods: type_of_payment_methods
  #   )
  # end

  # def list_receipts_and_payment_methods_xlsx(conn, %{"search" => search}) do
  #   dateformat = Timex.today() |> Timex.format!("%d%m%Y", :strftime)
  #   receipts = Admins.filter_receipt_and_payment_method(search)
  #   conn
  #   |> put_resp_content_type("text/xlsx")
  #   |> put_resp_header("content-disposition", "attachment; filename=receipts_and_payment_methods_#{dateformat}.xlsx;")
  #   |> render("receipts_and_payment_methods.xlsx", %{receipts: receipts})
  # end

end
