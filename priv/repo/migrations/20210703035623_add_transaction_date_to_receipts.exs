defmodule Donation.Repo.Migrations.AddTransactionDateToReceipts do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      add :transaction_date, :date
    end
  end
end
