defmodule Donation.MassOfferings.MassOfferingItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.MassOffering

  schema "mass_offering_items" do
    field :type_of_mass, :string
    field :number_of_mass, :integer
    field :specific_dates, :date
    field :to_whom, :string
    field :intention, :string
    belongs_to( :mass_offering, MassOffering )
    timestamps()
  end

  @doc false
  def changeset(mass_offering_item, attrs) do
    mass_offering_item
    |> cast( attrs, [:type_of_mass, :number_of_mass, :specific_dates, :to_whom, :intention] )
    |> validate_required([:type_of_mass, :number_of_mass, :specific_dates, :to_whom, :intention])
    |> assoc_constraint(:mass_offering)
  end
end
