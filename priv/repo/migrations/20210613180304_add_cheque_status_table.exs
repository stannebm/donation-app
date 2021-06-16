defmodule Donation.Repo.Migrations.AddChequeStatusTable do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      add :status, :integer, default: 1 # 1 - Active, 2 - Inactive, 3 - Cancelled
      add :cheque, :string
    end
  end
end
