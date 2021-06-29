defmodule DonationWeb.Plugs.SetCurrentAdmin do
  import Plug.Conn

  alias Donation.Admins

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      current_user = user_id && Admins.get_user!(user_id) ->
        conn
        |> assign(:current_admin, current_user)
        |> assign(:admin_signed_in?, true)

      true ->
        conn
        |> assign(:current_admin, nil)
        |> assign(:admin_signed_in?, false)
    end
  end
end
