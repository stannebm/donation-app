defmodule Donation.Revenue.MassOffering do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:contribution, :type_of_mass, :mass_language, :dates, :intention]}
  schema "mass_offerings" do
    belongs_to(:contribution, Donation.Revenue.Contribution)
    field(:type_of_mass, :string)
    field(:mass_language, :string)
    field(:dates, {:array, :date})
    field(:intention, :string)
    field(:delete, :boolean, virtual: true)
    timestamps()
  end

  @doc false
  def changeset(intention, attrs) do
    intention
    |> cast(attrs, [:type_of_mass, :mass_language, :dates, :intention, :delete])
    |> set_delete_action
    |> validate_required([:type_of_mass, :mass_language, :dates])
    |> assoc_constraint(:contribution)
  end

  defp set_delete_action(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
