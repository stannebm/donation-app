defmodule Donation.Repo.Migrations.AddChequeStatusTable do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      # 1 - Done, 2 - Pending, 3 - Cancelled
      add :status, :integer, default: 1
      add :cheque, :string
    end
  end
end
