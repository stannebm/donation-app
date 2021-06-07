defmodule Donation.Repo.Migrations.CreateReceiptItems do
  use Ecto.Migration
  def change do
    create table(:receipt_items) do
      add :receipt_id, references(:receipts, on_delete: :delete_all), null: false
      add :type_of_contribution_id, references(:type_of_contributions), null: false
      add :others, :string
      add :remark, :string
      add :price, :decimal, precision: 12, scale: 2, default: 0
      timestamps()
    end
    create index(:receipt_items, [:receipt_id])
    create index(:receipt_items, [:type_of_contribution_id])
  end
end
