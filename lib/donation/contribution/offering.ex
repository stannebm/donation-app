defmodule Donation.Contribution.Offering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.Contribution.Intention

  schema "offerings" do
    field(:referenceNo, :string)
    field(:type, :string)
    field(:fromWhom, :string)
    field(:contactNumber, :string)
    field(:emailAddress, :string)
    field(:massLanguage, :string)
    field(:amount, :decimal, precision: 12, scale: 2)
    field(:fpx_callback, :map)
    field(:cybersource_callback, :map)
    has_many(:intentions, Intention, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [
      :referenceNo,
      :type,
      :fromWhom,
      :contactNumber,
      :emailAddress,
      :massLanguage,
      :amount,
      :fpx_callback,
      :cybersource_callback
    ])
    |> validate_required([
      :referenceNo,
      :type,
      :fromWhom,
      :contactNumber,
      :emailAddress,
      :massLanguage,
      :amount
    ])
    |> unique_constraint(:referenceNo)
    |> cast_assoc(:intentions)
  end
end
