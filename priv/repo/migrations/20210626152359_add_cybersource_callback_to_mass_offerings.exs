defmodule Donation.Repo.Migrations.AddCybersourceCallbackToMassOfferings do
  use Ecto.Migration

  def change do
    alter table(:mass_offerings) do
      add :cybersource_callback, :map, default: %{}
    end
  end
end
