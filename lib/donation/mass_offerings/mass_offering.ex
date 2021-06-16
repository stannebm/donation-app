defmodule Donation.MassOfferings.MassOffering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.Offering

  schema "mass_offerings" do
    field :fromWhom,      :string
    field :contactNumber, :string
    field :emailAddress,  :string
    field :massLanguage,  :string
    field :uuid,          :string
    field :amount,        :decimal, precision: 12, scale: 2
    field :fpx_callback,  :map
    has_many( :offerings, Offering, on_replace: :delete )
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [:fromWhom, :contactNumber, :emailAddress, :massLanguage, :uuid, :amount, :fpx_callback])
    |> validate_required([:fromWhom, :contactNumber, :emailAddress, :massLanguage, :uuid, :amount])
    |> cast_assoc( :offerings )
  end
end

# API module
# {
#   "offerings": [
#     {
#       "typeOfMass": "Special Intention",
#       "intention": "this is a special intention",
#       "otherIntention": "this is an other intention",
#       "dates": ["01/06/2021", "02/06/2021"],
#     },
#     {
#       "typeOfMass": "Thanksgiving",
#       "intention": "this is thanksgiving",
#       "otherIntention": "this is an other intention",
#       "dates": ["01/06/2021", "02/06/2021"]
#     },
#     {
#       "typeOfMass": "Departed Soul",
#       "intention": "this is for departed soul",
#       "otherIntention": "this is an other intention",
#       "dates": ["01/06/2021", "02/06/2021"]
#     }
#   ],
#   "contactNumber": "0102020333",
#   "emailAddress": "zen9.felix@gmail.com",
#   "fromWhom": "Felix",
#   "massLanguage": "English",
#   "uuid": "9357666c-9103-46a4-a7e8-ca7f8832283c",
#   "amount": 50.00,
#   "fpx_callback": { "fpx_txnCurrency": "MYR", "fpx_sellerId": "SE0013401", "fpx_sellerExId": "EX0011982" }
# }