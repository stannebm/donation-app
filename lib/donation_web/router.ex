defmodule DonationWeb.Router do
  use DonationWeb, :router

  alias Donation

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticate_admin do
    plug(DonationWeb.Plugs.SetCurrentAdmin)
    plug(DonationWeb.Plugs.AuthenticateAdmin)
  end

  pipeline :layout_admin do
    plug(:put_layout, {DonationWeb.LayoutView, :admin})
  end

  scope "/api", DonationWeb do
    pipe_through(:api)
    post("/donation_form", WebFormApiController, :donation_form)
    post("/mass_offering_form", WebFormApiController, :mass_offering_form)

    post(
      "/payment_notification/:payment_provider",
      WebPaymentApiController,
      :payment_notification
    )
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :donation, swagger_file: "swagger.json")
  end

  ## WITHOUT AUTHENTICATE
  scope "/admins", DonationWeb do
    pipe_through([:browser])
    get("/sign-in", SessionController, :new)
    post("/sign-in", SessionController, :create)
    delete("/sign-out", SessionController, :delete)
  end

  ## WITH AUTHENTICATE
  scope "/admins", DonationWeb do
    pipe_through([:browser, :authenticate_admin, :layout_admin])
    resources("/receipts", ReceiptController, except: [:delete])
    get("/receipts/:id/generate_pdf", ReceiptController, :generate_pdf)
    resources("/type_of_contributions", TypeOfContributionController)
    resources("/type_of_payment_methods", TypeOfPaymentMethodController)
    resources("/users", UserController)
  end

  scope "/admins", DonationWeb, as: :admin do
    pipe_through [:browser, :authenticate_admin, :layout_admin]
    get("/dashboard", DashboardController, :dashboard)
    resources("/mass_offerings", MassOfferingController)
    # get("/mass_offerings/send_email/:contribution_id", MassOfferingController, :send_email)
    ## REPORTS
    get("/reports/list_donations", ReportController, :list_donations)
    get("/reports/list_donations/xlsx", ReportController, :list_donations_xlsx)
    get("/reports/list_mass_offerings", ReportController, :list_mass_offerings)
    get("/reports/list_mass_offerings/pdf", ReportController, :list_mass_offerings_pdf)
    get("/reports/list_mass_offerings/xlsx", ReportController, :list_mass_offerings_xlsx)
    ## FINANCIAL MANAGEMENT
    get("/reports/list_receipts_and_contributions", ReportController, :list_receipts_and_contributions)
    get("/reports/list_receipts_and_contributions/xlsx", ReportController, :list_receipts_and_contributions_xlsx)
    # get("/reports/list_receipts_and_payment_methods", ReportController, :list_receipts_and_payment_methods)
    # get("/reports/list_receipts_and_payment_methods/xlsx", ReportController, :list_receipts_and_payment_methods_xlsx)
  end

  scope "/admins", DonationWeb, as: :admin do
    pipe_through([:browser, :authenticate_admin, :layout_admin])
    get("/mass_offering_mail", EmailController, :mass_offering_mail)
  end

  scope "/", DonationWeb do
    pipe_through(:browser)
    # delegate to react router here
    get("/*path", PageController, :index)
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Mass Offerings & Donations"
      }
    }
  end
end
