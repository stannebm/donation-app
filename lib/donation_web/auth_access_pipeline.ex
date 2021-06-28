defmodule Donation.AuthAccessPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :donation,
    module: Donation.Guardian,
    error_handler: Donation.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
