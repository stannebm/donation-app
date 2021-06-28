defmodule Donation.Repo.Migrations.CreateReceipts do
  use Ecto.Migration

  def change do
    create table(:receipts) do
      add :user_id, references(:users, on_delete: :nothing), null: false

      add :type_of_payment_method_id, references(:type_of_payment_methods, on_delete: :nothing),
        null: false

      add :donor_name, :string, null: false
      add :receipt_number, :string, null: false
      add :total_amount, :decimal, precision: 12, scale: 2, default: 0
      timestamps()
    end

    create index(:receipts, [:user_id])
    create index(:receipts, [:type_of_payment_method_id])
  end
end
