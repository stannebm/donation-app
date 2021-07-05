defmodule Donation.Repo.Migrations.ModifyContributionsTable do
  use Ecto.Migration

  def change do
    alter table(:contributions) do
      modify(:email, :string, null: true)
      modify(:contact_number, :string, null: true)
    end
  end
end
