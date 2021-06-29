defmodule Donation.Repo.Migrations.CreateContributionDomain do
  use Ecto.Migration

  def change do
    create table(:contributions) do
      add :type, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :contact_number, :string, null: false
      add :amount, :decimal, precision: 12, scale: 2, default: 0
      add :payment_method, :string, null: false # FPX/Cybersource/Cheque/Cash/etc
      timestamps()
    end

    create table(:web_payments, primary_key: false) do
      add :reference_no, :bigint, primary_key: true
      add :contribution_id, references(:contributions, on_delete: :nothing), null: false
      add :verified, :boolean, default: false
      add :txn_info, :map, default: %{}
      add :extra_info, :map, default: %{}
      timestamps()
    end

    create table(:donations) do
      add :contribution_id, references(:contributions, on_delete: :delete_all), null: false
      add :intention, :string
      timestamps()
    end

    create table(:mass_offerings) do
      add :contribution_id, references(:contributions, on_delete: :delete_all), null: false
      add :type_of_mass, :string, null: false
      add :mass_language, :string, null: false
      add :dates, {:array, :date}
      add :intention, :string
      timestamps()
    end

    create index(:web_payments, [:contribution_id])
    create index(:donations, [:contribution_id])
    create index(:mass_offerings, [:contribution_id])
  end
end
