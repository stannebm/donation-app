defmodule DonationWeb.Router do
  use DonationWeb, :router

  alias Donation
  # alias Donation.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :authenticated_jwt do
  #   plug Donation.AuthAccessPipeline
  # end

  # https://whatdidilearn.info/2018/02/25/phoenix-authentication-and-authorization-using-plugs.html
  pipeline :authenticate_admin do
    plug DonationWeb.Plugs.SetCurrentAdmin
    plug DonationWeb.Plugs.AuthenticateAdmin
  end

  pipeline :layout_admin do
    plug :put_layout, { DonationWeb.LayoutView, :admin }
  end

  scope "/api", DonationWeb do
    pipe_through :api
    resources "/mass_offerings", MassOfferingController, except: [:new, :edit] do
      resources "/offerings", MassOfferingItemController, except: [:new, :edit]
    end
  end

  # scope "/api", DonationWeb do
  #   pipe_through [:api, :authenticated_jwt]
  # end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :donation, swagger_file: "swagger.json"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DonationWeb.Telemetry
    end
  end

  scope "/admins", DonationWeb do
    pipe_through [ :browser ]
    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
  end

  scope "/admins", DonationWeb do
    pipe_through [ :browser, :authenticate_admin, :layout_admin ]
    resources "/receipts", ReceiptController, except: [:delete]
    get "/receipts/:id/generate_pdf", ReceiptController, :generate_pdf
    resources "/reports", ReportController, only: [:index]
    resources "/type_of_contributions", TypeOfContributionController
    resources "/type_of_payment_methods", TypeOfPaymentMethodController
    resources "/users", UserController
  end

  scope "/", DonationWeb do
    pipe_through :browser

    get "/*path", PageController, :index
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
