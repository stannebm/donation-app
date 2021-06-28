defmodule Donation.Repo.Migrations.ChangeMassOfferingTable do
  use Ecto.Migration

  def change do
    drop table("mass_offering_items")
    drop table("mass_offerings")

    create table(:mass_offerings) do
      add :fromWhom, :string, null: false
      add :emailAddress, :string
      add :contactNumber, :string
      add :massLanguage, :string
      timestamps()
    end

    create table(:offerings) do
      add :typeOfMass, :string
      add :intention, :string
      add :dates, {:array, :date}
      add :mass_offering_id, references(:mass_offerings, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:offerings, [:mass_offering_id])
  end
end
