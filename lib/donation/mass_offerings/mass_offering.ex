defmodule Donation.MassOfferings.MassOffering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.Offering

  schema "mass_offerings" do
    field :fromWhom, :string
    field :contactNumber, :string
    field :emailAddress, :string
    field :massLanguage, :string
    field :uuid, :string
    field :amount, :decimal, precision: 12, scale: 2
    field :fpx_callback, :map
    field :cybersource_callback, :map
    has_many(:offerings, Offering, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [
      :fromWhom,
      :contactNumber,
      :emailAddress,
      :massLanguage,
      :uuid,
      :amount,
      :fpx_callback,
      :cybersource_callback
    ])
    |> validate_required([:fromWhom, :contactNumber, :emailAddress, :massLanguage, :uuid, :amount])
    |> unique_constraint(:uuid)
    |> cast_assoc(:offerings)
  end
end
