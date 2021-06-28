defmodule Donation.Contribution.Intention do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.Contribution.Offering

  schema "intentions" do
    field(:typeOfMass, :string)
    field(:intention, :string)
    field(:otherIntention, :string)
    field(:dates, {:array, :date})
    belongs_to(:offering, Offering)
    timestamps()
  end

  @doc false
  def changeset(mass_offering_item, attrs) do
    mass_offering_item
    |> cast(attrs, [:typeOfMass, :intention, :otherIntention, :dates])
    |> validate_required([:typeOfMass, :dates])

    # ensure parent exists
    |> assoc_constraint(:offering)
  end
end
