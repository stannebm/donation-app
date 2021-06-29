defmodule Donation.WebForms.DonationForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:verified, :boolean)
    field(:txn_info, :map)
    field(:extra_info, :map)
    timestamps()
  end

  @doc false
  def changeset(offering, attrs) do
    offering
    |> cast(attrs, [:verified, :txn_info, :extra_info])
  end
end
