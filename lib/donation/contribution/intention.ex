defmodule Donation.Contribution.Intention do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.Contribution.Offering

  schema "intentions" do
    field(:type_of_mass, :string)
    field(:intention, :string)
    field(:other_intention, :string)
    field(:dates, {:array, :date})
    belongs_to(:offering, Offering)
    timestamps()
  end

  @doc false
  def changeset(mass_offering_item, attrs) do
    mass_offering_item
    |> cast(attrs, [:type_of_mass, :intention, :other_intention, :dates])
    |> validate_required([:type_of_mass, :dates])

    # ensure parent exists
    |> assoc_constraint(:offering)
  end
end
