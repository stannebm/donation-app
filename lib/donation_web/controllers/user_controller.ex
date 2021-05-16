defmodule DonationWeb.UserController do
  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Admins.User
  alias Donation.Guardian

  action_fallback DonationWeb.FallbackController

  def index(conn, _params) do
    users = Admins.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Admins.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = Admins.get_user!(id)
  #   render(conn, "show.json", user: user)
  # end

  def show(conn, _params) do
     user = Guardian.Plug.current_resource(conn)
     conn 
     |> render("user.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Admins.get_user!(id)

    with {:ok, %User{} = user} <- Admins.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Admins.get_user!(id)

    with {:ok, %User{}} <- Admins.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case Admins.token_sign_in(username, password) do
      {:ok, token, _claims} 
        -> conn |> render("jwt.json", jwt: token)
      _ -> {:error, :unauthorized}
    end
  end

end
