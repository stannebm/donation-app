defmodule Donation.MassOfferings.MassOffering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.Offering

  schema "mass_offerings" do
    field :fromWhom,      :string
    field :contactNumber, :string
    field :emailAddress,  :string
    field :massLanguage,  :string
    has_many( :offerings, Offering, on_replace: :delete )
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [:fromWhom, :contactNumber, :emailAddress, :massLanguage])
    |> validate_required([:fromWhom, :contactNumber, :emailAddress, :massLanguage])
    |> cast_assoc( :offerings )
  end
end

# API module
# {
#   "offerings": [
#     {
#       "typeOfMass": "Special Intention",
#       "intention": "this is a special intention",
#       "dates": ["01/06/2021", "02/06/2021"]
#     },
#     {
#       "typeOfMass": "Thanksgiving",
#       "intention": "this is thanksgiving",
#       "dates": ["01/06/2021", "02/06/2021"]
#     },
#     {
#       "typeOfMass": "Departed Soul",
#       "intention": "this is for departed soul",
#       "dates": ["01/06/2021", "02/06/2021"]
#     }
#   ],
#   "contactNumber": "0102020333",
#   "emailAddress": "zen9.felix@gmail.com",
#   "fromWhom": "Felix",
#   "massLanguage": "English"
# }