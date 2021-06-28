defmodule Donation.Repo.Migrations.CreateInitialMassOfferings do
  use Ecto.Migration

  def change do
    create table(:offerings) do
      add :reference_no, :string, null: false
      add :type, :string, null: false # donation/mass_offering
      add :name, :string, null: false
      add :email, :string, null: false
      add :contact_number, :string, null: false
      add :mass_language, :string, default: ""
      add :amount, :decimal, precision: 12, scale: 2, default: 0
      add :fpx_txn_info, :map, default: %{}
      add :cybersource_txn_info, :map, default: %{}
      add :transferred, :boolean, default: false
      timestamps()
    end

    create table(:intentions) do
      add :type_of_mass, :string, null: false
      add :intention, :string
      add :other_intention, :string
      add :dates, {:array, :date}
      add :offering_id, references(:offerings, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:intentions, [:offering_id])
  end
end
