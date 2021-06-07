defmodule DonationWeb.Plugs.AuthenticateAdmin do

  import Plug.Conn
  import Phoenix.Controller
  import DonationWeb.Router.Helpers

  alias Donation.Admins

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.admin_signed_in? do
      conn
    else
      conn
        |> put_flash(:error, 'You need to be signed in to access this page')
        |> redirect(to: session_path(conn, :new))
        |> halt()
    end
  end

end
