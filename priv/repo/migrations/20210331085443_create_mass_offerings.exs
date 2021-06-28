defmodule Donation.Repo.Migrations.CreateMassOfferings do
  use Ecto.Migration

  def change do
    create table(:mass_offerings) do
      add :contact_name, :string, null: false
      add :contact_number, :string, null: false
      add :email_address, :string, null: false
      timestamps()
    end
  end
end
