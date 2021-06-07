defmodule Donation.Repo.Migrations.CreateTypeOfContributions do
  use Ecto.Migration

  def change do
    create table(:type_of_contributions) do
      add :name, :string
      add :price, :decimal, precision: 12, scale: 2, default: 0
      timestamps()
    end
  end

end
