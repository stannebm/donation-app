defmodule DonationWeb.UserView do
  use DonationWeb, :view
end

# defmodule DonationWeb.UserView do
#   use DonationWeb, :view
#   alias DonationWeb.UserView

#   def render("index.json", %{users: users}) do
#     %{data: render_many(users, UserView, "user.json")}
#   end

#   def render("show.json", %{user: user}) do
#     %{data: render_one(user, UserView, "user.json")}
#   end

#   def render("user.json", %{user: user}) do
#     %{id: user.id,
#       username: user.username,
#       password_hash: user.password_hash,
#       name: user.name,
#       is_admin: user.is_admin}
#   end

#   def render("jwt.json", %{jwt: jwt}) do
#     %{jwt: jwt}
#   end

# end
