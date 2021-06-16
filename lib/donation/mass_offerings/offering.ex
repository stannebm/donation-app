defmodule Donation.MassOfferings.Offering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.MassOffering

  schema "offerings" do
    field :typeOfMass, :string
    field :intention, :string
    field :otherIntention, :string
    field :dates, {:array, :date}
    belongs_to(:mass_offering, MassOffering)
    timestamps()
  end

  @doc false
  def changeset(mass_offering_item, attrs) do
    mass_offering_item
    |> cast(attrs, [:typeOfMass, :intention, :otherIntention, :dates])
    |> validate_required([:typeOfMass, :dates])
    |> assoc_constraint(:mass_offering)
  end
end
