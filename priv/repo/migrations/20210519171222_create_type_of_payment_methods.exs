defmodule Donation.Repo.Migrations.CreateTypeOfPaymentMethods do
  use Ecto.Migration

  def change do
    create table(:type_of_payment_methods) do
      add :name, :string
      timestamps()
    end
  end
end
