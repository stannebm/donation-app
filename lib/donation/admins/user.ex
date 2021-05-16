defmodule Donation.Admins.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :name, :is_admin])
    |> validate_required([:username, :password, :name, :is_admin])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{password: pass} }
        -> put_change( changeset, :password_hash, Bcrypt.Base.hash_password(pass, Bcrypt.gen_salt(12, true)) )
      _ -> changeset
    end
  end

end
