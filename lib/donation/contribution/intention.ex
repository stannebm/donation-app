defmodule Donation.Contribution.Intention do
  use Ecto.Schema
  import Ecto.Changeset
  alias Donation.Contribution.Offering

  @doc """
  Intention can refer to mass intention or donation intention
  and is always referring to an offering
  """

  schema "intentions" do
    field(:type_of_mass, :string)
    field(:intention, :string)
    field(:other_intention, :string)
    field(:dates, {:array, :date})
    belongs_to(:offering, Offering)
    timestamps()
  end

  @doc false
  def changeset(intention, attrs) do
    intention
    |> cast(attrs, [:intention, :dates, :other_intention, :type_of_mass])
    |> validate_required([:intention, :dates])

    # ensure parent exists
    |> assoc_constraint(:offering)
  end
end
