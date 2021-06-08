defmodule DonationWeb.UserController do
  use DonationWeb, :controller

  alias Donation.Admins
  alias Donation.Admins.User

  action_fallback DonationWeb.FallbackController

  def index(conn, _params) do
    users = Admins.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Admins.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Admins.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Admins.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Admins.get_user!(id)
    changeset = Admins.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Admins.get_user!(id)

    case Admins.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Admins.get_user!(id)
    {:ok, _user} = Admins.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

end

#   # def login(conn, %{"username" => username, "password" => password}) do
#   #   case Admins.token_sign_in(username, password) do
#   #     {:ok, token, _claims} 
#   #       -> conn |> render("jwt.json", jwt: token)
#   #     _ -> {:error, :unauthorized}
#   #   end
#   # end
