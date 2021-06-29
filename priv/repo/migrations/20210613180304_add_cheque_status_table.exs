defmodule Donation.Repo.Migrations.AddChequeStatusTable do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      # 1 - Active, 2 - Inactive, 3 - Cancelled
      add :status, :integer, default: 1
      add :cheque, :string
    end
  end
end
