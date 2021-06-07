# https://nithinbekal.com/posts/phoenix-authentication/
# https://elixircasts.io/user-authentication-with-phoenix
# https://maneesh.dev/user-authentication-phoenix-1-4-ebda68016740

defmodule DonationWeb.SessionController do
  use DonationWeb, :controller

  alias Donation.Admins

  action_fallback DonationWeb.FallbackController

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    case Admins.auth(auth_params["username"], auth_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.receipt_path(conn, :index))
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Invalid username or password. Please try again.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> assign(:current_user, nil)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end

end
