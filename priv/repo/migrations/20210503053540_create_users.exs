defmodule Donation.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :encrypted_password, :string, null: false
      add :is_admin, :boolean, default: false, null: false
      add :name, :string
      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
