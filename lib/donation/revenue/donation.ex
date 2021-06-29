defmodule Donation.Revenue.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:contribution, :intention]}
  schema "donations" do
    belongs_to(:contribution, Donation.Revenue.Contribution)
    field(:intention, :string)
    timestamps()
  end

  @doc false
  def changeset(intention, attrs) do
    intention
    |> cast(attrs, [:intention])
    |> validate_required([:intention])
    |> assoc_constraint(:contribution)
  end
end
