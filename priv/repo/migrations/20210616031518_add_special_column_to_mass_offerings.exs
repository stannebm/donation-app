defmodule Donation.Repo.Migrations.AddSpecialColumnToMassOfferings do
  use Ecto.Migration

  def change do
    alter table(:mass_offerings) do
      add :uuid, :string
      add :amount, :decimal, precision: 12, scale: 2, default: 0
      add :fpx_callback, :map, default: %{}
    end
    alter table(:offerings) do
      add :otherIntention, :string
    end
  end
end
