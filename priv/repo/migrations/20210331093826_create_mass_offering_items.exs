defmodule Donation.Repo.Migrations.CreateMassOfferingItems do
  use Ecto.Migration

  def change do
    create table(:mass_offering_items) do
      add :type_of_mass, :string, null: false
      add :number_of_mass, :integer, null: false
      add :specific_dates, :date
      add :to_whom, :string, null: false
      add :intention, :string, null: false
      add :mass_offering_id, references(:mass_offerings, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:mass_offering_items, [:mass_offering_id])
  end
end
